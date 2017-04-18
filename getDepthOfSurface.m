%Returns the mean the values in the normal direction from all vertices
%of faces facing the normal direction
function depth = getDepthOfSurface(targetPoints, vertices, faces, faceNormals, normal)
    surfaceIndices = getSameDirectionFaceIndices(faceNormals, normal);
    intersectedFaces = raysFacesIntersect(vertices, faces, targetPoints, normal, 1, surfaceIndices);
    
    vertices = vertices(unique(faces(intersectedFaces,:)),:);
    depth = mean(vertices*normal');
    
    %Sanity check (if this fails then the targetPoints are not positioned
    %over any faces
    if isempty(intersectedFaces)
        warning('No intersected faces')
        depth = 0;
    end
end