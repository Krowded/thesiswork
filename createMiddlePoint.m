function[vertices, faces, middlePointIndex] = createMiddlePoint(vertices, faces, newVertices, normal)    
    midPoint = calculateCentroid(newVertices,normal);
    [intersectedFaces] = unique(raysFacesIntersect(vertices, faces, [newVertices; midPoint], -normal, 1), 'stable');
    
    %Sanity check (won't work if ray cast misses)
    if isempty(intersectedFaces)
        error('intersects no face')
    end
    
    %Remove faces without matching normal
    %(Could possibly use stored normals instead)
    i = 1;
    while i < length(intersectedFaces)
        triangle = faces(intersectedFaces(i),:);
        v1 = vertices(triangle(2),:) - vertices(triangle(1),:);
        v2 = vertices(triangle(3),:) - vertices(triangle(1),:);
        
        %Normalize and check for slightly more than zero to rule out highly
        %angled faces
        vnormal = normalize(cross(v1,v2));
        if dot(normal, vnormal) < 0.05
            intersectedFaces(i) = [];
            continue;
        end
        i = i + 1;        
    end
    
    %Set point depth to same as wall
    midPoint = midPoint - normal.*dot(normal,midPoint) + normal.*dot(normal,mean((vertices(faces(intersectedFaces,1),:))));
    middlePointIndex = size(vertices,1) + 1;
    vertices(middlePointIndex,:) = midPoint;
    
    %Connect each face that contour will hit to midpoint
    for i = 1:length(intersectedFaces)
        faceIndex = intersectedFaces(i);
        face = faces(faceIndex,:);
        faces(faceIndex, 3) = middlePointIndex;
        faces((end+1):(end+2),:) = [ face(1), middlePointIndex, face(3); 
                                     middlePointIndex, face(2:3) ];
    end
end