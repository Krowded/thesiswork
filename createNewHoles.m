function [vertices, faces] = createNewHoles(vertices, faces, holeIndices, lengthsOfHoles, normal, optional_normals)
    if nargin < 6
        normals = calculateNormals(vertices,faces); %Could save a couple of calculations doing this later, but it hurts readability
    else
        normals = optional_normals;
    end
    
    normal = normalize(normal);
    %Remove sideways faces (and their normals)
    facesToRemove = getPerpendicularFaceIndices(normals, normal);
    faces(facesToRemove,:) = [];
    normals(facesToRemove,:) = [];
    
    for j = 1:2
        if j == 2
            normal = -normal;
        end
        
        %Get faces with matching normal
        facesToCheck = getSameDirectionFaceIndices(normals, normal);

        %Set depth of the holes [SHOULDNT BE HERE]1
        thisSideVerticeIndices = unique(faces(facesToCheck,:));
        meanDepth = mean(vertices(thisSideVerticeIndices,:)*normal');
        e = length(holeIndices);
        startIndex = (j-1)*(e/2)+1;
        endIndex = j*(e/2);
        vertices(holeIndices(startIndex:endIndex),:) = vertices(holeIndices(startIndex:endIndex),:)...
                                                       - normal.*(vertices(holeIndices(startIndex:endIndex),:)*normal')...
                                                       + normal.*meanDepth;
        
        %Set up constraint edges
        edges = createEdgeLoops(holeIndices(startIndex:endIndex),lengthsOfHoles);
        
        %Remove faces that will be retriangulated, retriangulate, and then
        %append the new ones
        indices = unique(faces(facesToCheck,:));
        indices = [indices(:)', holeIndices(startIndex:endIndex)];
        faces(facesToCheck,:) = [];
        normals(facesToCheck,:) = [];
        faces = [faces; constrainedDelaunayTriangulation(vertices, indices, edges, normal)];
    end    
    
    %Create faces between the depth levels ("window sills")
     for i = 1:length(lengthsOfHoles)
         numberOfVerticesPerLevel = lengthsOfHoles(i);
         faces = [faces; fillWindingFaces(numberOfVerticesPerLevel, 2, holeIndices)];
     end
    
    %Clean up
    [vertices, faces] = removeUnreferencedVertices(vertices,faces);
end