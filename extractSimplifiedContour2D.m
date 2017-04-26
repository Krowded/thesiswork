%Does the same thing as extractContour2D but also removes redundant vertices
function [vertices,indices] = extractSimplifiedContour2D(vertices, optional_indices)
    if nargin < 2
        optional_indices = 1:size(vertices,1);
    end
    
    [vertices, indices] = extractContour2D(vertices, optional_indices);
    
    %Remove points on the same line (done automatically in convex hull calculations)
%     [vertices, tempIndices] = simplifyContour(vertices, 1:size(vertices,1));
%     indices = indices(tempIndices);

    %Remove vertices too close to each other (maybe unnecessary)
    tempIndices = 1:size(vertices,1);
    [vertices, ~, tempIndices] = remove2DDuplicatePoints(vertices, tempIndices);
    indices = indices(tempIndices);
end