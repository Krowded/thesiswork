%Removes a list of vertices and all faces associated with them
function [vertices,faces] = removeVerticesAndFaces(vertices, faces, vertexIDs)
    vertices(vertexIDs,:) = [];
    
    i = 1;
    while i < size(faces,1)
        if ~isempty(intersect(faces(i,:),vertexIDs,'stable'))
            faces(i,:) = [];
            continue;
        end
        i = i + 1;
    end
    
    %Decrement indices in faces
    tempFaces = faces;
    for i = 1:length(vertexIDs)
        indices = tempFaces(:) > vertexIDs(i);
        faces(indices) = faces(indices) - 1;
    end
end