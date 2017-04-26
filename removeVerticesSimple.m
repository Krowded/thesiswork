%Removes a list of vertices and adjusts face indices accordingly
%(Assumes that the vertex is not referenced by a face)
function [vertices,faces] = removeVerticesSimple(vertices, faces, vertexIDs)
    %For safety, check for duplicates
    vertexIDs = unique(vertexIDs);

    %Remove vertices in question
    vertices(vertexIDs,:) = [];
    
    %Decrement indices in faces
    originalFaces = faces;
    originalFaces(:);
    for i = 1:length(vertexIDs)
        indices = originalFaces(:) > vertexIDs(i);
        faces(indices) = faces(indices) - 1;
    end
end