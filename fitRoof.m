function [foundationStructs, roofM, newRoofShape] = fitRoof(foundationStructs, newRoofShape)
    %Match roof slots
    roofM = matchSlots(newRoofShape.slots, foundationStructs(1).slots, 'non-uniform', foundationStructs(1).frontVector, foundationStructs(1).upVector);
    newRoofShape.slots = applyTransformation(newRoofShape.slots, roofM);
    newRoofShape.vertices = applyTransformation(newRoofShape.vertices, roofM);    
    
    %Project each wall point upwards and extend them to intersection
    for i = 1:length(foundationStructs)
        foundationStructs(i) = extendUp(foundationStructs(i), newRoofShape);
    end
end