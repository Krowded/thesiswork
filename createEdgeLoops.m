function [edges] = createEdgeLoops(indexChains, lengthsOfChains)
    edges = [];
    startingIndex = 1;
    endingIndex = 0;
    for i = 1:length(lengthsOfChains)
        endingIndex = endingIndex + lengthsOfChains(i);
        edges = [edges; createEdgeLoop(indexChains(startingIndex:endingIndex))];
        startingIndex = endingIndex + 1;
    end
end