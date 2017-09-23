%Curves the vertices of a model using the combined curving model.
%extraVertices are curved according to the combined model, but without
%affecting it, meaning it uses the parameters from the model instead of
%itself. (Meant for slots)
function [model, extraVertices] = curveModelCombined(model, curves, extraVertices)
    if nargin < 3
        extraVertices = [];
    end
    
    yMax = -Inf;
    for i = 1:length(curves)
        upVector = curves(i).otherDirection;
        heights = model.vertices*upVector';
        minHeight = min(heights);
        maxHeight = max(heights);
        scale = 100/(maxHeight - minHeight);
        invscale = 1/scale;
        yMax = max(yMax, invscale*max(curves(i).vertices(:,1)));
    end
    
    totalChange = zeros(size(model.vertices));
    totalChangeExtra = zeros(size(extraVertices));
    
    for i = 1:length(curves)
        upVector = curves(i).otherDirection;
        heights = model.vertices*upVector';
        minHeight = min(heights);
        maxHeight = max(heights);
        scale = 100/(maxHeight - minHeight);
        invscale = 1/scale;
        heights = (heights - minHeight)*scale;
        if ~isempty(extraVertices)
            heightsExtra = extraVertices*upVector';
            heightsExtra = (heightsExtra - minHeight)*scale;
            totalChangeExtra = zeros(size(extraVertices));
        end
        
        curvingDirection = curves(i).normal';
        curveFun = curves(i).curveFunction;
        
        %Calculate curve according to height
        y = invscale*arrayfun(curveFun, heights);
        baseY = y(1); %Lock to side, natural point of levelness (since that's where it connects)

        %See where they will end up without scaling, and then use that for
        %scaling with distance from edge
        tempVert = model.vertices + y.*curvingDirection;
        positionsInDirection = tempVert*curvingDirection';
        maxForward = max(positionsInDirection);
        maxBackward = min(positionsInDirection);
        mid = (maxForward + maxBackward)/2;
        distance = (positionsInDirection - mid)./abs(maxForward-mid);
        distanceRatio = distance .* (distance > 0);
        
        %Apply to model vertices
%         model.vertices = model.vertices + distanceRatio.*y.*curvingDirection - distanceRatio.*baseY*curvingDirection;
        totalChange = totalChange + distanceRatio.*y.*curvingDirection - distanceRatio.*baseY*curvingDirection;

        %Again for extraVertices
        if ~isempty(extraVertices)            
            y = invscale*arrayfun(curveFun, heightsExtra);
            
            tempVert = extraVertices - y*curvingDirection;
            positionsInDirection = tempVert*curvingDirection';
            distance = (positionsInDirection - mid)./abs(maxForward-mid);
            distanceRatio = abs(distance .* (distance > 0));

%             extraVertices = extraVertices + distanceRatio.*y.*curvingDirection - distanceRatio.*baseY*curvingDirection;
            totalChangeExtra = totalChangeExtra + distanceRatio.*y.*curvingDirection - distanceRatio.*baseY*curvingDirection;
        end
    end
    
    %Apply everything
    model.vertices = model.vertices + totalChange;
    if ~isempty(extraVertices)
        extraVertices = extraVertices + totalChangeExtra;
    end
    
    if any(any(isnan(model.vertices))) || any(any(isnan(extraVertices)))
        error('Something went wrong during curveModelCombined. Answer contained NaN.')
    end
end