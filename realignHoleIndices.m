%Realigns the winding order for all holes
function holeIndices = realignHoleIndices(vertices, holeIndices, lengthsOfHoles, normal)
    for i = 1:length(lengthsOfHoles)
        for j = 1:2
            startIndex = 2*sum(lengthsOfHoles(1:(i-1))) + 1 + (j-1)*lengthsOfHoles(i);
            endIndex = startIndex - 1 + lengthsOfHoles(i);
            holeIndices(startIndex:endIndex) = realignWindingOrder(vertices, holeIndices(startIndex:endIndex), normal);
        end
    end
end