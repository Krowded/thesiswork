function [edges, outputHoleIndices] = createWallEdgeLoops(holeIndices, lengthsOfHoles, frontOrBack)
    if strcmp(frontOrBack, 'front')
        j = 1;
    elseif strcmp(frontOrBack, 'back')
        j = 2;
    else
        error('Need to specify front or back')
    end

    edges = [];
    outputHoleIndices = [];
    for i = 1:length(lengthsOfHoles)
        %Set up indices
        e = lengthsOfHoles(i);
        startIndex = 2*sum(lengthsOfHoles(1:(i-1))) + (j-1)*e + 1;
        endIndex = startIndex - 1 + e;

        %Set up constraint edges
        edges = [edges; createEdgeLoops(holeIndices(startIndex:endIndex), lengthsOfHoles(i))];
        outputHoleIndices = [outputHoleIndices; holeIndices(startIndex:endIndex)];
    end
end