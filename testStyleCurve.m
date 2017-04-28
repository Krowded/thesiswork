magicHouse = loadAndPrepareModelFolder('testMagicHouse');
magicFoundationStructs = magicHouse.foundation.models;

lowestHighestPoint = Inf;
for i = 1:length(magicFoundationStructs)
    lowestHighestPoint = min(lowestHighestPoint, max(magicFoundationStructs(i).vertices*magicFoundationStructs(i).upVector'));
end

%lowestHighestPoints = Inf;
curves = struct('vertices', [], 'curveFunction', [], 'curveLength', [], 'span', []);
for i = 1:length(magicFoundationStructs)
    wallStruct = magicFoundationStructs(i);
    wallStruct.vertices = wallStruct.vertices(wallStruct.vertices*wallStruct.upVector' < (lowestHighestPoint - 0.001), :);
    curves(i) = getWallCurve(wallStruct);
end

%Make a new foundation
%foundationStructs = buildSquareFoundation(20000, 10000, 2000);
foundationStructs = buildAnySidedFoundation(4, 40000, 10000, 10000);

maxIndex = length(foundationStructs);
[foundationStructs(1), foundationStructs(maxIndex), foundationStructs(2)] = curveWallTimesFour(foundationStructs(1), foundationStructs(maxIndex), foundationStructs(2), curves, [0, 0, 1]);
for i = 2:maxIndex-1
    [foundationStructs(i), foundationStructs(i-1), foundationStructs(i+1)] = curveWallTimesFour(foundationStructs(i), foundationStructs(i-1), foundationStructs(i+1), curves, [0, 0, 1]); 
end
[foundationStructs(maxIndex), foundationStructs(maxIndex-1), foundationStructs(1)] = curveWallTimesFour(foundationStructs(maxIndex), foundationStructs(maxIndex-1), foundationStructs(1),  curves, [0, 0, 1]);


foundationStruct = mergeModels(foundationStructs);

write_ply(foundationStruct.vertices, foundationStruct.faces, 'test.ply');