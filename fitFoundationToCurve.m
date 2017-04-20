%Takes all vertices above the lowest slot and changes their heights to
%match the curve 
function vertices = fitFoundationToCurve(vertices, lowestChangableHeight, curve, xdirection, ydirection)
    heights = vertices*ydirection';
    margin = 0.001;
    indicesToChange = heights > (lowestChangableHeight-margin);
    
    vertices(indicesToChange,:) = fitModelToCurve(vertices(indicesToChange,:), curve, xdirection, ydirection);
end