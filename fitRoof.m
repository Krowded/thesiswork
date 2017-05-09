function [foundationStructs, roofM, changedAndNewIndices, roofCurveStructs, newRoofShape] = fitRoof(foundationStructs, newRoofShape)
    %Match roof slots
    roofM = matchSlots(newRoofShape.slots, foundationStructs(1).slots, 'uniform', foundationStructs(1).frontNormal, foundationStructs(1).upVector);
    newRoofShape.slots = applyTransformation(newRoofShape.slots, roofM);
    newRoofShape.vertices = applyTransformation(newRoofShape.vertices, roofM);
    
    %Fit foundation to roof curve
    lowestChangableHeight = min(foundationStructs(1).slots*foundationStructs(1).upVector');
    changedAndNewIndices = cell(1,length(foundationStructs));
    for i = 1:length(foundationStructs)
        %TODO: CHANGE CURVE CALCULATION TO LINE-TRIANGLE INTERSECTION WITH A SUBSET OF FACES FOR EXACT VALUES (PROBABLY SLOWER THOUGH)
        curveStruct = getCurveUnderRoof(newRoofShape, foundationStructs(i));
        roofCurveStructs(i) = curveStruct;
        [foundationStructs(i), changedAndNewIndices{i}] = fitWallToRoofCurve(foundationStructs(i), lowestChangableHeight, curveStruct.curveFunction, curveStruct.curveLength);
    end
end