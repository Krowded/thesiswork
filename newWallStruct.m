%Inherit from modelstruct when porting
function wallStruct = newWallStruct(vertices, faces, faceNormals, frontIndices, backIndices, normal)
    wallStruct.vertices = vertices;
    wallStruct.faces = faces;
    wallStruct.faceNormals = faceNormals;
    wallStruct.frontIndices = frontIndices;
    wallStruct.backIndices = backIndices;
    wallStruct.frontNormal = normal;
end