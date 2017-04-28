function wallStruct = curveWall(wallStruct, curveFunction)
    wallStruct.vertices(wallStruct.frontIndices,:) = curveVertices(wallStruct.vertices(wallStruct.frontIndices,:), curveFunction, wallStruct.upVector, wallStruct.frontNormal);
end