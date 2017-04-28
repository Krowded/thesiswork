function curveStructs = getFoundationCurves(wallStructs)
    lowestHighestPoint = Inf;
    for i = 1:length(wallStructs)
        lowestHighestPoint = min(lowestHighestPoint, max(wallStructs(i).vertices*wallStructs(i).upVector'));
    end

    %lowestHighestPoints = Inf;

    curveStructs = struct('vertices', [], 'curveFunction', [], 'curveLength', [], 'span', [], 'normal', []);
    for i = 1:length(wallStructs)
        wallStruct = wallStructs(i);
        wallStruct.vertices = wallStruct.vertices(wallStruct.vertices*wallStruct.upVector' < (lowestHighestPoint - 0.001), :);
        curveStructs(i) = getWallCurve(wallStruct);
    end
end