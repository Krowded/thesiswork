function wallStruct = calculateFrontAndBackIndices(wallStruct)
    if isempty(wallStruct.faceNormals)
        wallStruct.faceNormals = calculateNormals(wallStruct.vertices, wallStruct.faces);
    end
    
    wallStruct.frontIndices = getSameDirectionVertexIndices(wallStruct.faces, wallStruct.faceNormals, wallStruct.frontNormal);
    wallStruct.backIndices = getSameDirectionVertexIndices(wallStruct.faces, wallStruct.faceNormals, -wallStruct.frontNormal);
end