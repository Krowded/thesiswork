%Returns a two dimensional version of vertices seen from the direction of
%the normal
function [ flattenedVertices ] = flattenVertices(vertices, normal)
    B = getBaseTransformationMatrix(normal);
    vertices = matrixMultByRow(vertices, B);
    flattenedVertices = vertices(:,1:2);
end