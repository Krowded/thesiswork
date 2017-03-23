%Takes an array of vertices and optionally one of indices for which
%vertices should be checked
%Returns a list of vertices with duplicates removed, and a list of the
%original indices of those vertices remaining
function [vertices, faces, indices] = remove2DDuplicatePoints(vertices, faces, indices)
    if ( size(vertices,2) ~= 2)
        error('Dimensions mismatch. Vertices need to be 2D.')
    end
    if nargin < 3
        indices = 1:size(vertices,1);
    end
    
    indicesOfIndicesToRemove = NaN(size(indices));
    index = 1;
    for i = 1:length(indices)
        vertexix = vertices(indices(i),1);
        vertexiy = vertices(indices(i),2);
        for j = (i+1):length(indices)
            vertexjx = vertices(indices(j),1);
            vertexjy = vertices(indices(j),2);
            if abs(vertexjx - vertexix) < 0.00001 && abs(vertexjy - vertexiy) < 0.00001
                indicesOfIndicesToRemove(index) = j;
                index = index + 1;
                faces(faces(:) == indices(j)) = indices(i);
            end
        end
    end
    indicesOfIndicesToRemove = indicesOfIndicesToRemove(~isnan(indicesOfIndicesToRemove));
    
    indices(indicesOfIndicesToRemove) = [];
    [vertices, faces] = removeVerticesSimple(vertices, faces, indicesOfIndicesToRemove);
end