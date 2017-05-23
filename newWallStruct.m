function wallStruct = newWallStruct(model)
    if nargin < 1
        wallStruct = newModelStruct();
    else
        wallStruct = model;
    end
    
    
    wallStruct.frontIndices = [];
    wallStruct.backIndices = [];
    wallStruct.frontCornerIndicesLeft = [];
    wallStruct.frontCornerIndicesRight = [];
    wallStruct.backCornerIndicesLeft = [];
    wallStruct.backCornerIndicesRight = [];
    wallStruct.frontTopIndices = [];
    wallStruct.backTopIndices = [];
    wallStruct.adjustment = 0;
    
    wallStruct.gridIndicesFront = [];
    wallStruct.gridIndicesBack = [];
end