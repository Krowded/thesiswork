%Takes an array of vertices and optionally one of indices for which
%vertices should be checked
%Returns a list of vertices with duplicates removed, and a list of the
%original indices of those vertices
function [outVertices, outIndices] = removeDuplicatePoints(vertices, indices)
    if exist('indices', 'var')
        vertices = vertices(indices,:);
    else
        indices = 1:size(vertices,1);
    end
    
    outIndices = indices;
    for i = 1:length(indices)
        for j = (i+1):length(indices)
            if norm(vertices(indices(i),:) - vertices(indices(j),:)) < 0.00001
                outIndices(j) = NaN;
            end
        end
    end
    outVertices = vertices(~isnan(outIndices),:);
    outIndices = outIndices(~isnan(outIndices));
end