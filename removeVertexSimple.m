%Removes a vertex and adjusts face indices accordingly
%(Assumes that the vertex is not referenced by a face)
function [vertices,faces] = removeVertexSimple(vertices, faces, vertexID)
    vertices(vertexID,:) = [];
    
    indices = faces(:) > vertexID;
    faces(indices) = faces(indices) - 1;
end