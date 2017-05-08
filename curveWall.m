function wallStruct = curveWall(wallStruct, indices, curveFunction, curveDirection, minHeight, maxHeight)
    wallStruct.vertices(indices,:) = curveVertices(wallStruct.vertices(indices,:), curveFunction, wallStruct.upVector, curveDirection, minHeight, maxHeight);
end