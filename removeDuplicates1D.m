function vertices = removeDuplicates1D(vertices, sortingDimension, maxingDimension)
    sortingVertices = vertices*sortingDimension';
    comparingVertices = vertices*maxingDimension';
    [sorted, I] = sort(sortingVertices, 'ascend');
    
    min = sorted(1);
    max = sorted(end);
    scale = 0.01/(max-min);
    
    %Sanity check
    if isnan(scale)
        error('Same max and min point');
    end
    
    diffs = diff(sorted);
    i = 1;
    while i < length(diffs)
        if abs(diffs(i))*scale < 0.00001
            if comparingVertices(i) > comparingVertices(i+1)
                comparingVertices(i+1) = [];
            else
                comparingVertices(i) = [];
            end
            diffs(i) = [];
            I(i) = [];
            
            continue;
        end
        
        i = i + 1;
    end
    
    vertices = vertices(I(:,1),:); 
end