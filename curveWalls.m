%Curves the walls by ombining them into a single model, curving the model
%according to curveStructs and then splitting them back up again
%Assumes frontVectors and curve normals are all in the same plane
function wallStructs = curveWalls(wallStructs, curveStructs)
    %Combine in one array
    previousIndex = 0;
    previousSlotIndex = 0;
    combinedVertices = [];
    combinedSlots = [];
    for i = 1:length(wallStructs)
        numOfVertices = size(wallStructs(i).frontIndices,1);
        combinedVertices((previousIndex+1):(previousIndex+numOfVertices),:) = wallStructs(i).vertices(wallStructs(i).frontIndices,:);
        previousIndex = previousIndex + numOfVertices;
        
        numOfSlots = size(wallStructs(i).slots,1);
        combinedSlots((previousSlotIndex+1):(previousSlotIndex+numOfSlots),:) = wallStructs(i).slots;
        previousSlotIndex = previousSlotIndex + numOfSlots;
    end

    %Curve
    [combinedVertices, combinedSlots] = curveVerticesCombined(combinedVertices, curveStructs, combinedSlots);

    %Put back
    previousIndex = 0;
    previousSlotIndex = 0;
    for i = 1:length(wallStructs)
        numOfVertices = size(wallStructs(i).frontIndices,1);
        wallStructs(i).vertices(wallStructs(i).frontIndices,:) = combinedVertices((previousIndex+1):(previousIndex+numOfVertices),:);
        previousIndex = previousIndex + numOfVertices;
        
        numOfSlots = size(wallStructs(i).slots,1);
        wallStructs(i).slots = combinedSlots((previousSlotIndex+1):(previousSlotIndex+numOfSlots),:);
        previousSlotIndex = previousSlotIndex + numOfSlots;
    end
end