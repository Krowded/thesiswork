function roofM = reFitRoof(foundationStructs, newRoofShape)
    %Match roof slots
    roofM = matchSlots(newRoofShape.slots, foundationStructs(1).slots, 'non-uniform', foundationStructs(1).frontVector, foundationStructs(1).upVector);
end