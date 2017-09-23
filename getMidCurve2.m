%Tries to compute a the central curve of a model (assumes entry and exit
%directions are normalized)
function [curvePoints] = getMidCurve2(model, entryDirection, exitDirection, curveMaxLength, precision)
    if nargin < 3
        exitDirection = entryDirection;
    end
    if nargin < 4
        curveMaxLength = Inf;
    end
    if nargin < 5
        precision = 100;
    end
    points = model.vertices; 
    
    
	%Get
    ydir = entryDirection;
    if norm(abs(ydir) - exitDirection) > 0.001
        temp = [0 0 1];
    elseif norm(abs(ydir) - model.frontVector) > 0.001
        temp = model.frontVector;
    else
        temp = model.upVector;
    end
    xdir = cross(ydir,temp);
    zdir = cross(xdir,ydir);
    
    
    contour1 = extractContourUsingFaces(model.vertices, model.faces, xdir);
    contour2 = extractContourUsingFaces(model.vertices, model.faces, zdir);     
    betterpcshow([contour1; contour1]);
end