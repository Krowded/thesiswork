function [wallStruct, maxMove] = curveWall(wallStruct, indices, curveFunction, curveDirection, minHeight, maxHeight)
    [wallStruct.vertices(indices,:), maxMove] = curveVertices(wallStruct.vertices(indices,:), curveFunction, wallStruct.upVector, curveDirection, minHeight, maxHeight);
end