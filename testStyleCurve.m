magicHouse = loadAndPrepareModelFolder('testMagicHouse');
foundationStructs = magicHouse.foundation.models;

lowestHighestPoint = Inf;
for i = 1:length(foundationStructs)
    lowestHighestPoint = min(lowestHighestPoint, max(foundationStructs(i).vertices*foundationStructs(i).upVector'));
end

lowestHighestPoints = Inf;
for i = 1:length(foundationStructs)
    wallStruct = foundationStructs(i);
    wallStruct.vertices = wallStruct.vertices(wallStruct.vertices*wallStruct.upVector' < (lowestHighestPoint - 0.001), :);
    curveVertices = getWallCurve(wallStruct);
    betterpcshow([curveVertices, zeros(size(curveVertices,1),1)])
end

write_ply(foundationStructs(2).vertices, foundationStructs(2).faces, 'test.ply', 'ascii')
