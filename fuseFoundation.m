%Closes off the roof around a flat level
function foundationStruct = fuseFoundation(foundationStructs)
    framePartLength = length(foundationStructs(1).gridIndicesFront(1,:)) - 1;
    frame = zeros(length(foundationStructs)*framePartLength,1);
    totalSize = 0;
    startingIndex = 1;
    for i = 1:length(foundationStructs)
        nextLineLength = length(foundationStructs(i).gridIndicesFront(1,1:(end-1)));
        frame(startingIndex:(startingIndex + nextLineLength - 1)) = foundationStructs(i).gridIndicesFront(1,1:(end-1)) + totalSize;
        totalSize = totalSize + size(foundationStructs(i).vertices,1);
        startingIndex = startingIndex + nextLineLength;
    end
    
    foundationStruct = mergeModels(foundationStructs);
    newFaces = retriangulateSurface(foundationStruct.vertices, frame, [], [], frame, length(frame), foundationStruct.upVector);
    foundationStruct.faces = [foundationStruct.faces; newFaces];
end