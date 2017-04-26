function modelStruct = removeFacesAboveModel(modelStruct)
    direction = modelStruct.frontNormal;
    
    %Slightly lower every point
    translation = modelStruct.upVector.*(-0.001);
    T = getTranslationMatrixFromVector(translation);    
    slightlyLowerVertices = applyTransformation(modelStruct.vertices, T);
    
    %Get faces intersected by lowered points
    indices = raysFacesIntersect(modelStruct.vertices, modelStruct.faces, slightlyLowerVertices, direction, 1);
    
    %Remove missed faces
    modelStruct.faces = modelStruct.faces(indices,:);    
end