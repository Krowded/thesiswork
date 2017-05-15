%Constructor
function holeStruct = newHoleStruct(frontIndices, backIndices)
    if nargin < 1
        frontIndices = [];
        backIndices = [];
    end

    holeStruct.holeLength = length(frontIndices);
    holeStruct.frontIndices = frontIndices;
    holeStruct.backIndices = backIndices;
end