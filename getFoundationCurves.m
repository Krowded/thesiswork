function curveStructs = getFoundationCurves(wallStructs)
    %Use only points below the lowest wall highpoint
    lowestHighestPoint = Inf;
    for i = 1:length(wallStructs)
        lowestHighestPoint = min(lowestHighestPoint, max(wallStructs(i).vertices*wallStructs(i).upVector'));
    end

    %lowestHighestPoint = Inf; %Remove height limit

    curveStructs = struct('vertices', [], 'curveFunction', [], 'curveLength', [], 'span', [], 'normal', []);
    for i = 1:length(wallStructs)
        wallStruct = wallStructs(i);
        wallStruct.vertices = wallStruct.vertices(wallStruct.vertices*wallStruct.upVector' < (lowestHighestPoint + 0.001), :);
        curveStructs(i) = getWallCurve(wallStruct);
    end
end