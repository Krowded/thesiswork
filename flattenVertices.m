function [ vertices ] = flattenVertices(vertices, normal)
    vertices = vertices - normal.*(vertices.*normal);
end