%Curves the vertices of a model using the combined curving model.
%extraVertices are curved according to the combined model, but without
%affecting it, meaning it uses the parameters from the model instead of
%itself. (Meant for slots)
function [model, extraVertices] = removeCurveCombined(model, curves, upVector, extraVertices)
    if nargin < 4
        extraVertices = [];
    end

    heights = model.vertices*upVector';
    maxHeight = max(heights);
    minHeight = min(heights);
    scale = 100/(maxHeight - minHeight);
    invscale = 1/scale;
    heights = (heights - minHeight)*scale;
    if ~isempty(extraVertices)
        heightsExtra = extraVertices*upVector';
        heightsExtra = (heightsExtra - minHeight)*scale;
    end
    
    for i = 1:length(curves)
        curvingDirection = curves(i).normal';
        curveFun = curves(i).curveFunction;
        
        %Calculate curve according to height
        y = invscale*arrayfun(curveFun, heights);
        baseY = y(1);

        
        tempVert = model.vertices - y.*curvingDirection;
       
        %Adapt according to distance from edge
%         positionsInDirection = model.vertices*curvingDirection';
        positionsInDirection = tempVert*curvingDirection';
        maxForward = max(positionsInDirection);
        maxBackward = min(positionsInDirection);
        mid = (maxForward + maxBackward)/2;
        distance = (positionsInDirection - mid)./abs(maxForward-mid);
        distanceRatio = distance .* (distance > 0);
        
        %Apply to model vertices
        model.vertices = model.vertices - distanceRatio.*y.*curvingDirection + distanceRatio.*baseY*curvingDirection;
        
        %Again for extraVertices
        if ~isempty(extraVertices)
            positionsInDirection = extraVertices*curvingDirection';
            distance = (positionsInDirection - mid)./abs(maxForward-mid);
            distanceRatio = abs(distance .* (distance > 0));
            y = invscale*arrayfun(curveFun, heightsExtra);
%             y = y - minY;
            extraVertices = extraVertices + distanceRatio.*y.*curvingDirection  + distanceRatio.*baseY*curvingDirection;
        end
    end
    
    if any(any(isnan(model.vertices))) || any(any(isnan(extraVertices)))
        error('Something went wrong during curveModelCombined. Answer contained NaN.')
    end
end