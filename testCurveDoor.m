% door = loadAndMergeModels('D:\School\Thesis\Matlabtest\Archive\door.ply');
door = found1;
% front = [1 0 0];
side = [0 0 -1];
up = [0 1 0];
sidePositions = door.vertices*side';
maxRightDoor = max(sidePositions);
maxLeftDoor = min(sidePositions);
mid = (maxRightDoor + maxLeftDoor)/2;

distance = (sidePositions - mid)./abs(maxRightDoor-mid);
leftDistanceRatio = abs(distance .* (distance < 0));
rightDistanceRatio = abs(distance .* (distance > 0));

% leftDistanceRatio = leftDistanceRatio.*leftDistanceRatio;
% rightDistanceRatio = rightDistanceRatio.*rightDistanceRatio;

heights = door.vertices*up';
minHeight = min(heights);
maxHeight = max(heights);

curveFunctionLeft = foundationCurves(2).curveFunction;
curveFunctionRight = foundationCurves(2).curveFunction;

%curveFunction exists between 0 and 100, so need to scale to that
scale = 100/(maxHeight - minHeight);
invscale = 1/scale;   

%Apply curve function to each vertex
heights = (heights - minHeight)*scale;
yleft = invscale*arrayfun(curveFunctionLeft, heights);
yleft = yleft - min(yleft);
yright = invscale*arrayfun(curveFunctionRight, heights);
yright = yright - min(yright);
door.vertices = door.vertices + leftDistanceRatio.*yleft.*(-side) + rightDistanceRatio.*yright.*(side);  


write_ply(door.vertices, door.faces, 'test.ply');