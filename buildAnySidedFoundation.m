function foundationStructs = buildAnySidedFoundation(numberOfWalls, radius, height, wallThickness)
    up = [0 1 0];
    front = [0 0 1];
    
    %Detail
    linesX = 2;
    linesY = 11;
    
    angleBetweenWalls = 360/numberOfWalls;
    
    width = radius * tand(angleBetweenWalls/2);
    
    foundationStructs = newModelStruct();
    for i = 1:numberOfWalls
        rads = -((i-1)*angleBetweenWalls/180)*pi;
        R = rotationVectorToMatrix(rads*up);
        forward = (R*front')';
        foundationStructs(i) = createWallFromSpecifications(-width, width, 0, height, radius-wallThickness, radius, forward, up, linesX, linesY, angleBetweenWalls, angleBetweenWalls);
        foundationStructs(i) = retriangulateWall(foundationStructs(i));
    end
end