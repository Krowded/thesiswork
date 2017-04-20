%Constructor
function holeStruct = newHoleStruct(frontIndices, backIndices)
    holeStruct.holeLength = length(frontIndices);
    holeStruct.frontIndices = frontIndices;
    holeStruct.backIndices = backIndices;
end