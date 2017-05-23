function mat = customVec2Mat(vec, numcolumns)
    numrows = length(vec)/numcolumns;
    
    mat = NaN(numrows, numcolumns);
    
    startingIndex = 1;
    for i = 1:numrows
        endingIndex = startingIndex + numcolumns - 1;
        mat(i, :) = vec(startingIndex:endingIndex);
        startingIndex = endingIndex + 1;
    end
end