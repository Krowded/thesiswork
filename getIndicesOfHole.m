function holeIndices = getIndicesOfHole(holeIndices, lengthsOfHoles, holeNumber)
    i = holeNumber;
    startIndex = 2*sum(lengthsOfHoles(1:(i-1))) + 1;
    endIndex = startIndex - 1 + 2*lengthsOfHoles(i);
    holeIndices = holeIndices(startIndex:endIndex);
end