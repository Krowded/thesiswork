function wallStruct = curveCorner(wallStruct, cornerIndices, curveFunction, curveDirection, minHeight, maxHeight)
    cornerVertices = wallStruct.vertices(cornerIndices,:);
    
    cornerVertices = curveVertices(cornerVertices, curveFunction, wallStruct.upVector, curveDirection, minHeight, maxHeight);
    
    wallStruct.vertices(cornerIndices,:) = cornerVertices;
end