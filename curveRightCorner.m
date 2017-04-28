function wallStruct = curveRightCorner(wallStruct, curveFunction, direction)
    rightCorner = wallStruct.vertices(wallStruct.cornerIndicesRight,:);
    
    rightCorner = curveVertices(rightCorner, curveFunction, wallStruct.upVector, direction);
    
    wallStruct.vertices(wallStruct.cornerIndicesRight,:) = rightCorner;
end