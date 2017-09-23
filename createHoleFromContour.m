function [wallStruct, holeStruct] = createHoleFromContour(wallStruct, contour)
    frontVector = wallStruct.frontVector;

    %Create new vertices for front and back part of wall
%     frontDepths = getDepthOfSurface(contour, wallStruct.vertices(wallStruct.frontIndices,:), frontVector);
%     backDepths = -getDepthOfSurface(contour, wallStruct.vertices(wallStruct.backIndices,:), -frontVector); %Negative normal gives negative depth
%     contourFront = contour - frontVector.*(contour*frontVector') + frontVector.*frontDepths;
%     contourBack = contour - frontVector.*(contour*frontVector') + frontVector.*backDepths;

    %Simpler version, since we now know it's always flat
    frontDepth = (wallStruct.vertices(wallStruct.frontIndices(1),:)*frontVector')*frontVector;
    backDepth = (wallStruct.vertices(wallStruct.backIndices(1),:)*(frontVector)')*frontVector;
    contourFront = contour - frontVector.*(contour*frontVector') + frontDepth;
    contourBack = contour - frontVector.*(contour*frontVector') + backDepth;


    %Insert contour into list of holes
    [wallStruct, holeStruct] = insertNewHole(wallStruct, contourFront, contourBack);
end