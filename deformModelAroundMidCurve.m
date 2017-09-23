function deformedModel = deformModelAroundMidCurve(model, midCurve, meanWidth, curveFunction)
    numPoints = size(midCurve,1);
    curveLengths = zeros(1,numPoints);
    for i = 1:numPoints
        curveLengths(i) = getCurveLength(midCurve(1:i));
    end
    scale = 100/curveLengths(end);
    invscale = 1/scale;   
    

    for i = 1:size(model,1)
        %Locate closest
        point = model.vertices(i,:);
        I = findClosestCurvePointIndex(point);
        closestCurvePoint = midCurve(I,:);
        
        if I == 1
            direction = normalize(midCurve(2,:) - midCurve(1,:));
        elseif I == numPoints
            direction = normalize(midCurve(end,:) - midCurve(end-1,:));
        else
            direction = normalize((midCurve(I+1,:) -  midCurve(I,:) + midCurve(I,:) - midCurve(I-1,:)));
        end
        
        vec = normalize(point - closestCurvePoint);
        vec = vec - (vec*direction')*direction;
        
        % Flatten to nearest meanWidth
        model.vertices(i,:) = closestCurvePoint + meanWidth*vec;
    
        %Apply curve function to each vertex
%         y = invscale*arrayfun(curveFunction, curveLengths(I));
%         model.vertices(i,:) = model.vertices(i,:) + y*vec;
    end
    
    deformedModel = model;
    
    function I = findClosestCurvePointIndex(point)
        [~,I] = min(norm(midCurve - point));
    end
end