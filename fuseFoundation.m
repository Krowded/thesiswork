function foundationStruct = fuseFoundation(foundationStructs, roofStruct)
    %Collect all foundation structs in a single struct
    foundationStruct = mergeModels(foundationStructs);
    
    %Add top part
    foundationStruct = createFoundationRoofConnection(foundationStruct, roofStruct);
end