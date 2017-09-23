function simplifiedRoofModel = simplifyRoofShape(roofModel, upVector)
    %Only keep the faces pointing up and vertices connected to them (fewer
    %vertices to deal with in next steps)
    down = -upVector;
    roofModel.faceNormals = calculateNormals(roofModel.vertices, roofModel.faces);
    roofModel.faces(any(isnan(roofModel.faceNormals),2),:) = [];
    roofModel.faceNormals(any(isnan(roofModel.faceNormals),2),:) = [];

    pointingUp = roofModel.faceNormals*down' < 0;
    roofModel.faces = roofModel.faces(pointingUp,:);
    [roofModel.vertices, roofModel.faces] = removeUnreferencedVertices(roofModel.vertices, roofModel.faces);
    simplifiedRoofModel = roofModel;
end