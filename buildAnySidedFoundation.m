function foundationStructs = buildAnySidedFoundation(numberOfWalls, radius, height, wallThickness)
    up = [0 1 0];
    front = [0 0 1];
    
    %Detail
    linesX = 20;
    linesY = 11;
    
    n = numberOfWalls;
    angleBetweenWalls = 360/numberOfWalls;
%     cornerAngle = ((n-2)*180/n)/2;
    cornerAngle = angleBetweenWalls/2;
    
    width = radius * tand(angleBetweenWalls/2);
    
    foundationStructs = newWallStruct();
    for i = 1:numberOfWalls
        rads = -((i-1)*angleBetweenWalls/180)*pi;
        R = rotationVectorToMatrix(rads*up);
        forward = (R*front')';
        
        leftCorner = [-width; 0; radius];
        rightCorner = [width; 0; radius];
        leftCorner = R*leftCorner;
        rightCorner = R*rightCorner;
        leftCorner = leftCorner([1 3]);
        rightCorner = rightCorner([1 3]);
        
        foundationStructs(i) = createWallFromSpecifications(leftCorner, rightCorner, height, wallThickness, forward, up, linesX, linesY, cornerAngle, cornerAngle);
        foundationStructs(i) = retriangulateWall(foundationStructs(i));
    end
end