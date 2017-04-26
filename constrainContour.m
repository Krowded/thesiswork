%Check if any vertices are below ground and return the transformation
%matrix to move them up
% [Expand this to keep things inside target walls entirely]
% [Alternatively allow for a lot of non-uniform scaling]
function [T] = constrainContour(wallVertices, contour, up)
    groundLevel = min(wallVertices*up');
    t = constrainAboveGround(contour, up, groundLevel);
    T = getTranslationMatrixFromVector(t);
end