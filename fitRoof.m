function [foundationStructs, roofM, changedAndNewIndices, roofCurveStructs, newRoofShape] = fitRoof(foundationStructs, newRoofShape)
    %Match roof slots
    roofM = matchSlots(newRoofShape.slots, foundationStructs(1).slots, 'uniform', foundationStructs(1).frontVector, foundationStructs(1).upVector);
    newRoofShape.slots = applyTransformation(newRoofShape.slots, roofM);
    newRoofShape.vertices = applyTransformation(newRoofShape.vertices, roofM);
    
    %Calculate curves
    roofCurveStructs = newModelStruct();
    changedAndNewIndices = cell(length(foundationStructs),1);
    for i = 1:length(foundationStructs)
        roofCurveStructs(i) = getFacesAroundModel(newRoofShape, foundationStructs(i));
       [foundationStructs(i), changedAndNewIndices{i}] = matchToAbove(foundationStructs(i), roofCurveStructs(i));
    end
    
    %Fit foundation to roof curve
%     lowestChangableHeight = min(foundationStructs(1).slots*foundationStructs(1).upVector');
%     changedAndNewIndices = cell(1,length(foundationStructs));
%     for i = 1:length(foundationStructs)
	
%         curveStruct = getCurveUnderRoof(newRoofShape, foundationStructs(i));
%         roofCurveStructs(i) = curveStruct;
%         [foundationStructs(i), changedAndNewIndices{i}] = fitWallToRoofCurve(foundationStructs(i), lowestChangableHeight, curveStruct.curveFunction, curveStruct.curveLength);
%     end
end