%Removes the hole at index holeToRemove in lengthsOfHoles
function [holeIndices, lengthsOfHoles] = removeHole(holeIndices, lengthsOfHoles, holeToRemove)
    startIndex = 2*sum(lengthsOfHoles(1:(holeToRemove-1))) + 1;
    endIndex = startIndex - 1 + 2*lengthsOfHoles(holeToRemove);
    holeIndices(startIndex:endIndex) = [];
    lengthsOfHoles(holeToRemove) = [];
end