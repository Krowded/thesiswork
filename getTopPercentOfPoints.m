function topPoints = getTopPercentOfPoints(points, up, percent)
    if nargin < 3
        percent = 10;
    end
    
    cutoff = (100 - percent)*0.01;
    heights = points*up';
    maxHeight = max(heights);
    minHeight = min(heights);
    topTenPercentIndices = heights > minHeight + cutoff*(maxHeight - minHeight);
    
    topPoints = points(topTenPercentIndices,:);
end