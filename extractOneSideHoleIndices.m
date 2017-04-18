%Returns a list of either all front or all back indices of the holes
function outputHoleIndices = extractOneSideHoleIndices(holeIndices, lengthsOfHoles, frontOrBack)
    if strcmp(frontOrBack, 'front')
        j = 1;
    elseif strcmp(frontOrBack, 'back')
        j = 2;
    else
        error('Need to specify front or back')
    end

    outputHoleIndices = [];
    for i = 1:length(lengthsOfHoles)
        %Set up indices
        e = lengthsOfHoles(i);
        startIndex = 2*sum(lengthsOfHoles(1:(i-1))) + (j-1)*e + 1;
        endIndex = startIndex - 1 + e;

        %Set up constraint edges
        outputHoleIndices = [outputHoleIndices; holeIndices(startIndex:endIndex)];
    end
end