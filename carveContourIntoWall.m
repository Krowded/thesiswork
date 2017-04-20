function [vertices, faces] = carveContourIntoWall(wallVertices, wallFaces, contourVertices, normal, normals)
    %Make hole in wall
    %wallNormals = calculateNormals(wallVertices, wallFaces);
    [vertices, faces] = createHoleFromContour(wallVertices, wallFaces, contourVertices, normals, normal);
end