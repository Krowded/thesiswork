%Does the same thing as extractContour2D but also removes redundant vertices
function [vertices,indices] = extractSimplifiedContour2D(vertices, optional_indices)
    if nargin < 2
        optional_indices = 1:size(vertices,1);
    end

    [vertices, indices] = extractContour2D(vertices, optional_indices);
    [vertices, tempIndices] = simplifyContour(vertices, 1:size(vertices,1));
    indices = indices(tempIndices);
end