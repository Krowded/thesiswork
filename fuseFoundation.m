%Adds 
function foundationStruct = fuseFoundation(foundationStructs, roofStruct)
    for i = 1:length(foundationStructs)
        foundationStructs(i) = fuseTopOfWall(foundationStructs(i));
    end


    %Put walls together
    foundationStruct = fuseWalls(foundationStructs);

    %Add vertices and faces to fill empty space between wall and roof
%     foundationStruct = createFoundationRoofConnection(foundationStruct, roofStruct);
end