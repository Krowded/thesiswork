function [topPoints, topPointIndices] = getTopPercentOfPoints(points, up, percent)
    if nargin < 3
        percent = 10;
    end
    
    cutoff = (100 - percent)*0.01;
    heights = points*up';
    maxHeight = max(heights);
    minHeight = min(heights);
    topPointPlaces = heights > minHeight + cutoff*(maxHeight - minHeight);
    
    topPointIndices = find(topPointPlaces);
    topPoints = points(topPointIndices,:);
end