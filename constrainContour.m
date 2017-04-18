%Check if any vertices are below ground and move them up 
% [Expand this to keep things inside target walls entirely]
% [Alternatively allow for a lot of non-uniform scaling]
function [constrainedContour, T] = constrainContour(wallVertices, contour, up)
    groundLevel = min(wallVertices*up');
    t = constrainAboveGround(contour, up, groundLevel);
    T = getTranslationMatrixFromVector(t);
    constrainedContour = applyTransformation(contour, T);
end