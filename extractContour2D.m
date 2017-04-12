%Takes 2D vertices and optionally indices, and returns the vertices
%of the 2D convex hull and their original indices arranged clockwise
function [vertices,indices] = extractContour2D(vertices, optional_indices)
    if nargin < 2
        optional_indices = 1:size(vertices,1);
    else
        vertices = vertices(optional_indices,:);
    end
    
    %Get counterclockwise
    wrappingIndices = convhull(vertices, 'simplify', true);
    indices = optional_indices(wrappingIndices);
    vertices = vertices(wrappingIndices,:);
end
