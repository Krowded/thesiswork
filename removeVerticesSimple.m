%Removes a list of vertices and adjusts face indices accordingly
%(Assumes that the vertex is not referenced by a face)
function [vertices,faces] = removeVerticesSimple(vertices, faces, vertexIDs)
    if isempty(vertexIDs)
        return;
    end

    %For safety, check for duplicates
    vertexIDs = unique(vertexIDs(:));

    %Remove vertices in question
    vertices(vertexIDs,:) = [];
    
    %Decrement indices in faces once for every removed smaller index
    faces(:) = faces(:) - sum(faces(:) > vertexIDs',2);
end