%Constructor
function holeStruct = newHoleStruct(frontIndices, backIndices, connectedWall)
    if nargin < 3
        connectedWall = 0;
    end
    if nargin < 1
        frontIndices = [];
        backIndices = [];
    end

    holeStruct.holeLength = length(frontIndices);
    holeStruct.frontIndices = frontIndices;
    holeStruct.backIndices = backIndices;
    holeStruct.connectedWall = connectedWall;
end