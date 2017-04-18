function [vertices, faces] = createHoleFromContour(wallVertices, wallFaces, contour, normals, normal)
    %Create new vertices for front and back part of wall
    frontDepth = getDepthOfSurface(contour, wallVertices, wallFaces, normals, normal);
    backDepth = -getDepthOfSurface(contour, wallVertices, wallFaces, normals, -normal); %Negative normal gives negative depth
    contourFront = contour - normal.*(contour*normal') + normal.*frontDepth;
    contourBack = contour - normal.*(contour*normal') + normal.*backDepth;

    %Set up list of holes
    holeIndices = [];
    lengthsOfHoles = [];

    %Insert door contour into list of holes
    contourHoleVertices = [contourFront; contourBack];
    [vertices, holeIndices, lengthsOfHoles] = insertNewHole(wallVertices, holeIndices, lengthsOfHoles, contourHoleVertices);
    
    %Retriangulate
    [faces] = createNewHoles(vertices, wallFaces, holeIndices, lengthsOfHoles, normal, normals); %We lose non-hole vertices. Look into it!
end