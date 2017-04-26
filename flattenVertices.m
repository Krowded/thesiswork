    %Returns a two dimensional version of vertices seen from the direction of
%the normal
function [ flattenedVertices ] = flattenVertices(vertices, normal)
    normal = normalize(normal);
    vertices = changeBasis(vertices, normal);
    flattenedVertices = vertices(:,1:2);
end