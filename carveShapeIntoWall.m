function [vertices, faces, transformationMatrix] = carveShapeIntoWall(wallVertices, wallFaces, newModelShape, wallBaseShape, normal, up, normals)
    %Fit to wall
    M = fitToWall(newModelShape, wallBaseShape, normal);

    %Get contour
    newModelContour = extractSimplifiedContour3D(newModelShape, normal);
    newModelContour = applyTransformation(newModelContour, M);

    %Constrain contour
    [newModelContour, T] = constrainContour(wallVertices, newModelContour, up);
    transformationMatrix = T*M;
    
    %Make hole in wall    
    %wallNormals = calculateNormals(wallVertices, wallFaces);
    [vertices, faces] = createHoleFromContour(wallVertices, wallFaces, newModelContour, normals, normal);
end