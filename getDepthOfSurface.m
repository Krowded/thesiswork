%Returns the depth value of the closest vertex (in the direction
%perpendicular to the normal) for each targetPoint
function depths = getDepthOfSurface(targetPoints, surfaceVertices, normal)
    depths = zeros(size(targetPoints,1),1);
    targetPoints = flattenVertices(targetPoints, normal);
    flatVertices = flattenVertices(surfaceVertices, normal);
    
    for i = 1:size(targetPoints,1)
        distances = flatVertices - targetPoints(i,:);
        distances = arrayfun(@(idx) norm(distances(idx,:)), 1:size(distances,1));
        [~,indexOfMin] = min(distances);
        depths(i) = surfaceVertices(indexOfMin,:)*normal';
    end
end