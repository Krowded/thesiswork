function wallStruct = curveLeftCorner(wallStruct, curveFunction, direction)
    leftCorner = wallStruct.vertices(wallStruct.cornerIndicesLeft,:);
    
    leftCorner = curveVertices(leftCorner, curveFunction, wallStruct.upVector, direction);
    
    wallStruct.vertices(wallStruct.cornerIndicesLeft,:) = leftCorner;
end