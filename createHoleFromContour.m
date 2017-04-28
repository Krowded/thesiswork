function [wallStruct, holeStruct] = createHoleFromContour(wallStruct, contour)
    normal = wallStruct.frontNormal;

    %Create new vertices for front and back part of wall
    frontDepths = getDepthOfSurface(contour, wallStruct.vertices(wallStruct.frontIndices,:), normal);
    backDepths = -getDepthOfSurface(contour, wallStruct.vertices(wallStruct.backIndices,:), -normal); %Negative normal gives negative depth
    contourFront = contour - normal.*(contour*normal') + normal.*frontDepths;
    contourBack = contour - normal.*(contour*normal') + normal.*backDepths;

    %Insert contour into list of holes
    [wallStruct, holeStruct] = insertNewHole(wallStruct, contourFront, contourBack);
end