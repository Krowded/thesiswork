function wallStruct = curveWall(wallStruct, curveFunction, minHeight, maxHeight)
    %Curve front part of wall
    if nargin < 3
        wallStruct.vertices(wallStruct.frontIndices,:) = curveVertices(wallStruct.vertices(wallStruct.frontIndices,:), curveFunction, wallStruct.upVector, wallStruct.frontNormal);
    else
        wallStruct.vertices(wallStruct.frontIndices,:) = curveVertices(wallStruct.vertices(wallStruct.frontIndices,:), curveFunction, wallStruct.upVector, wallStruct.frontNormal, minHeight, maxHeight);
    end
end