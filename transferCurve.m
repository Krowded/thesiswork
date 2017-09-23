function targetModel = transferCurve(targetModel, exemplarModel, rotationVectorTarget, rotationVectorExemplar)
    if nargin < 3
        rotationVectorTarget = targetModel.upVector;
        rotationVectorExemplar = exemplarModel.upVector;
    end
    
    numOfAngles1 = 4;
    baseVector = exemplarModel.frontVector';
    directions = zeros(numOfAngles1, 3);
    otherVector = exemplarModel.upVector';
    otherDirections = zeros(numOfAngles1, 3);
    for i = 1:numOfAngles1
        rot = (2/numOfAngles1)*pi*(i-1);
        R = rotationVectorToMatrix(rotationVectorExemplar*rot);
        directions(i,:) = R*baseVector;
        otherDirections(i,:) = R*otherVector;
    end   
    
    for i = 1:numOfAngles1
        newCurves(i).vertices = getCurveVertices(exemplarModel.vertices, directions(i,:), otherDirections(i,:));
        newCurves(i).curveFunction = @(xq) interp1(newCurves(i).vertices(:,2), newCurves(i).vertices(:,1), xq, 'linear', 'extrap');
    end

    numOfAngles2 = 4;
    baseVector = targetModel.frontVector;
    directions = zeros(numOfAngles2, 3);
    otherVector = targetModel.upVector;
    otherDirections = zeros(numOfAngles2, 3);
    for i = 1:numOfAngles2
        rot = (2/numOfAngles2)*pi*(i-1);
        R = rotationVectorToMatrix(rotationVectorTarget*rot);
        directions(i,:) = R*baseVector';
        otherDirections(i,:) = R*otherVector';
    end
    
    for i = 1:numOfAngles2        
        newCurves(i).normal = directions(i,:)'; %Change to same as target for application
        newCurves(i).otherDirection = otherDirections(i,:);
        oppositeOldCurves(i).normal = directions(i,:)';
        oppositeOldCurves(i).otherDirection = otherDirections(i,:);
        oppositeOldCurves(i).vertices = getCurveVertices(targetModel.vertices, oppositeOldCurves(i).normal', otherDirections(i,:));
        oppositeOldCurves(i).curveFunction = @(xq) interp1(oppositeOldCurves(i).vertices(:,2), -oppositeOldCurves(i).vertices(:,1), xq, 'linear', 'extrap');
    end

    [targetModel, slots] = curveModelCombined(targetModel, oppositeOldCurves, targetModel.slots);
%     [targetModel, slots] = removeCurveCombined(targetModel, oldCurves, targetModel.upVector, targetModel.slots);
%     [targetModel, slots] = curveModelCombined(targetModel, newCurves, slots
    targetModel.slots = slots;
end