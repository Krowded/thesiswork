function wallStruct = fuseTopOfWall(wallStruct)
    indices = [wallStruct.frontTopIndices; wallStruct.backTopIndices];
    newFaces = constrainedDelaunayTriangulation(wallStruct.vertices, indices, [], [], wallStruct.upVector);
    
    %Append new faces
    wallStruct.faces = [wallStruct.faces; newFaces];
end
