function foundationStructs = buildSquareFoundation(width, height, wallThickness)
    up = [0 1 0];
    front = [0 0 1];
    left = [-1 0 0];
    right = [1 0 0];
    back = [0 0 -1];
    forward = [front; left; back; right];
    
    linesX = 3;
    linesY = 11;
    
    angleBetweenWalls = 90;
    
    foundationStructs = newModelStruct();
    for i = 1:4
        foundationStructs(i) = createWallFromSpecifications(-width*0.5, width*0.5, 0, height, width*0.5-wallThickness, width*0.5, forward(i,:), up, linesX, linesY, angleBetweenWalls, angleBetweenWalls);
        foundationStructs(i) = retriangulateWall(foundationStructs(i));
    end
end