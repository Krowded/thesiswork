function wallStruct = createWallFromSpecifications(leftCorner, rightCorner, height, thickness, forward, up, numberOfLinesX, numberOfLinesY, cornerAngleLeft, cornerAngleRight)
    minX = leftCorner(1);
    maxX = rightCorner(1);
    minY = 0;
    maxY = height;
    leftZ = leftCorner(2);
    rightZ = rightCorner(2);

    %Setup
    wallStruct = newWallStruct();
    wallStruct.frontVector = forward;
    wallStruct.upVector = up;
    wallStruct.sideVector = normalize(cross(wallStruct.upVector, wallStruct.frontVector));    
    
    densityX = numberOfLinesX - 1;
    densityY = numberOfLinesY - 1;
    distanceBetweenLinesX = (maxX - minX)/densityX;
    distanceBetweenLinesY = (maxY - minY)/densityY;
    distanceBetweenLinesZ = (rightZ - leftZ)/densityX;
    
    %Calculate difference between back and front to get proper angle
    diff = thickness;
    adjustmentMin = sqrt((diff/cosd(cornerAngleLeft))^2 - diff^2);
    if isnan(adjustmentMin), adjustmentMin = 0; end
    adjustmentMax = sqrt((diff/cosd(cornerAngleRight))^2 - diff^2);
    if isnan(adjustmentMax), adjustmentMax = 0; end

    
%   Back can just be a simple square
    numberOfLinesBackX = 2;
    numberOfLinesBackY = 2;
    backVertices = [ minX maxY leftZ;
                     maxX maxY rightZ;
                     minX minY leftZ
                     maxX minY rightZ;];
    backVertices([1 3],:) = backVertices([1 3],:) - adjustmentMin*wallStruct.sideVector; %Match to connecting wall
    backVertices([2 4],:) = backVertices([2 4],:) + adjustmentMax*wallStruct.sideVector;
    backVertices = backVertices - wallStruct.frontVector*thickness;
                 
    %Front is a full grid
    frontVertices = zeros(numberOfLinesX*numberOfLinesY, 3);
    frontVertices(:,3) = rightZ;
    for i = 1:numberOfLinesY
        frontVertices(((i-1)*numberOfLinesX+1):(i*numberOfLinesX), 2) = minY + (numberOfLinesY-i)*distanceBetweenLinesY;
    end
    
    for i = 1:numberOfLinesX
        frontVertices(i:numberOfLinesX:size(frontVertices,1), 1) = minX + (i-1)*distanceBetweenLinesX;
        frontVertices(i:numberOfLinesX:size(frontVertices,1), 3) = leftZ + (i-1)*distanceBetweenLinesZ;
    end
    
    %Insert into structure
    wallStruct.vertices = [frontVertices; backVertices];
    
    wallStruct.frontIndices = (1:size(frontVertices,1))';
    wallStruct.gridIndicesFront = customVec2Mat(wallStruct.frontIndices, numberOfLinesX);
    
    wallStruct.backIndices = ((size(frontVertices,1)+1):(size(frontVertices,1)+size(backVertices,1)))';
    wallStruct.gridIndicesBack = customVec2Mat(wallStruct.backIndices, numberOfLinesBackX);
    
    %Save corner indices for curving purposes
    wallStruct.frontCornerIndicesLeft = wallStruct.gridIndicesFront(:,1);
    wallStruct.frontCornerIndicesRight = wallStruct.gridIndicesFront(:,end);
    wallStruct.backCornerIndicesLeft = wallStruct.gridIndicesBack(:,1);
    wallStruct.backCornerIndicesRight = wallStruct.gridIndicesBack(:,end);
    
    %Save top indices for similar stuff
    wallStruct.frontTopIndices = wallStruct.gridIndicesFront(1,:)';
    wallStruct.backTopIndices = wallStruct.gridIndicesBack(1,:)';
end