%Takes an array of vertices and optionally one of indices for which
%vertices should be checked
%Returns a list of vertices with duplicates removed, a list of adjusted faces,
%and a list of the original indices of those vertices remaining
function [vertices, faces, remainingIndices] = remove2DDuplicatePoints(vertices, faces, indices)
    if ( size(vertices,2) ~= 2)
        error('Dimensions mismatch. Vertices need to be 2D.')
    end
    if nargin < 3
        indices = 1:size(vertices,1);
    end
    
    indicesOfIndicesToRemove = NaN(size(indices));
    index = 1;
    for i = 1:(length(indices)-1)
        vertexi = vertices(indices(i),:);
        for j = (i+1):length(indices)
            vertexj = vertices(indices(j),:);
            if norm(vertexi - vertexj) < 0.00001
                indicesOfIndicesToRemove(index) = j;
                index = index + 1;
                faces(faces(:) == indices(j)) = indices(i);
            end
        end
    end
    indicesOfIndicesToRemove = indicesOfIndicesToRemove(~isnan(indicesOfIndicesToRemove));
    
    remainingIndices = indices;
    remainingIndices(indicesOfIndicesToRemove) = [];
    [vertices, faces] = removeVerticesSimple(vertices, faces, indices(indicesOfIndicesToRemove));
end