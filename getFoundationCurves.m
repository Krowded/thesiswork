function curveStructs = getFoundationCurves(wallStructs)
    %Use only points below the lowest wall highpoint
    lowestHighestPoint = Inf;
    for i = 1:length(wallStructs)
        lowestHighestPoint = min(lowestHighestPoint, max(wallStructs(i).vertices*wallStructs(i).upVector'));
    end
    
    %     lowestHighestPoint = Inf; %Remove height limit

    curveStructs = newCurveStruct();
    index = 1;
    if length(wallStructs) > 1 %Attempt one curve for each wall part
        for i = 1:length(wallStructs)
            wallStruct = wallStructs(i);
            wallStruct.vertices = wallStruct.vertices(wallStruct.vertices*wallStruct.upVector' < (lowestHighestPoint + 0.001), :);

            curveStruct = getWallCurve(wallStruct);
            if ~isempty(curveStruct)
                curveStructs(index) = curveStruct;
                index = index + 1;
            end
        end
    else %Assume 4 walls if not provided
        wallStructs.vertices = wallStructs.vertices(wallStructs.vertices*wallStructs.upVector' < (lowestHighestPoint + 0.001), :);
        rotationVector = wallStructs.upVector * pi/2;
        R = rotationVectorToMatrix(rotationVector);
        for i = 1:4
            curveStruct = struct();
            curveStruct.vertices = getCurveVertices(wallStructs.vertices, wallStructs.frontVector, wallStructs.upVector);
            if ~isempty(curveStruct.vertices)
                curveStruct.curveFunction = string('linear');
                curveStruct.curveLength = size(curveStruct.vertices,1);
                curveStruct.normal = wallStructs.frontVector;
                curveStructs(index) = curveStruct;
                index = index + 1;
            end
            wallStructs.frontVector = (R*wallStructs.frontVector')';
        end
    end
end