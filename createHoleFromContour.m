function [wallStruct, holeStruct] = createHoleFromContour(wallStruct, contour)
    frontVector = wallStruct.frontVector;

    %Create new vertices for front and back part of wall
    frontDepths = getDepthOfSurface(contour, wallStruct.vertices(wallStruct.frontIndices,:), frontVector);
    backDepths = -getDepthOfSurface(contour, wallStruct.vertices(wallStruct.backIndices,:), -frontVector); %Negative normal gives negative depth
    contourFront = contour - frontVector.*(contour*frontVector') + frontVector.*frontDepths;
    contourBack = contour - frontVector.*(contour*frontVector') + frontVector.*backDepths;

    %Insert contour into list of holes
    [wallStruct, holeStruct] = insertNewHole(wallStruct, contourFront, contourBack);
end