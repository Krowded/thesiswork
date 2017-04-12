%Removes all holes matching the indices holesToRemove in lengthsOfHoles
function [holeIndices, lengthsOfHoles] = removeHoles(holeIndices, lengthsOfHoles, holesToRemove)
    while ~isempty(holesToRemove)
        holeToRemove = max(holesToRemove);
        holesToRemove(holesToRemove == holeToRemove) = [];
        [holeIndices, lengthsOfHoles] = removeHole(holeIndices, lengthsOfHoles, holeToRemove);
    end
end