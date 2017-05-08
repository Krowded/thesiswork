function foundationStruct = fuseFoundation(foundationStructs, roofStruct)
    %Create faces between wall sections and store in foundationStructs(1)
    verticesPerStrip = length(foundationStructs(1).frontCornerIndicesLeft);
    numberOfFacesPerPair = 2*verticesPerStrip - 2;
    numberOfWalls = length(foundationStructs);
    numberOfFaces = numberOfFacesPerPair*numberOfWalls;
    newFaces = zeros(numberOfFaces,3);
    totalSize = 0;
    for i = 1:(numberOfWalls-1)
        stripRight = foundationStructs(i).frontCornerIndicesLeft + totalSize;
        totalSize = totalSize + size(foundationStructs(i).vertices,1);
        stripLeft = foundationStructs(i+1).frontCornerIndicesRight + totalSize;
        
        for j = 1:(verticesPerStrip-1)
            newFaces((i-1)*numberOfFacesPerPair + (2*j)-1,:) = [stripLeft(j), stripRight(j), stripLeft(j+1)];
            newFaces((i-1)*numberOfFacesPerPair + (2*j),:) = [stripLeft(j+1), stripRight(j), stripRight(j+1)];
        end
    end
    
    stripRight = foundationStructs(end).frontCornerIndicesLeft + totalSize;
    stripLeft = foundationStructs(1).frontCornerIndicesRight;

    for j = 1:(verticesPerStrip-1)
        newFaces((numberOfWalls-1)*numberOfFacesPerPair + (2*j)-1,:) = [stripLeft(j), stripRight(j), stripLeft(j+1)];
        newFaces((numberOfWalls-1)*numberOfFacesPerPair + (2*j),:) = [stripLeft(j+1), stripRight(j), stripRight(j+1)];
    end
    
    %Collect all foundation structs in a single struct
    foundationStruct = mergeModels(foundationStructs);
    
    %Append new faces
    foundationStruct.faces = [foundationStruct.faces; newFaces];
    
    %Add top part
    foundationStruct = createFoundationRoofConnection(foundationStruct, roofStruct);
end