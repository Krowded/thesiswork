%Curves the walls by combining them into a single model, curving the model
%according to curveStructs and then splitting them back up again
%Assumes frontVectors and curve normals are all in the same plane
function wallStructs = curveWalls(wallStructs, curveStructs)
    combinedModel = mergeModels(wallStructs);

    [combinedModel, combinedModel.slots] = curveModelCombined(combinedModel, curveStructs, combinedModel.slots); % combinedModel.upVector,
    
    previousIndex = 0;
    previousIndexSlots = 0;
    
    for i = 1:length(wallStructs)
        wallStructs(i).vertices = combinedModel.vertices(previousIndex + (1:size(wallStructs(i).vertices,1)),:);
        wallStructs(i).slots = combinedModel.slots(previousIndexSlots + (1:size(wallStructs(i).slots,1)),:);
        previousIndex = previousIndex + size(wallStructs(i).vertices,1);
        previousIndexSlots = previousIndexSlots + size(wallStructs(i).slots,1);
    end
end