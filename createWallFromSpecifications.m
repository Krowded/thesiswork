function wallStruct = createWallFromSpecifications(leftCorner, rightCorner, height, thickness, forward, up, numberOfLinesX, numberOfLinesY, cornerAngleLeft, cornerAngleRight)
    maxY = height;
    minY = 0;

    %Setup
    wallStruct = newWallStruct();
    wallStruct.frontVector = forward;
    wallStruct.upVector = up;
    wallStruct.sideVector = normalize(cross(wallStruct.upVector, wallStruct.frontVector));    
                 
    %Front grid
    %Save distances for later extensions
    [frontVertices, wallStruct.lineDistanceX, wallStruct.lineDistanceY] = makeGrid(leftCorner, rightCorner, minY, maxY, numberOfLinesX, numberOfLinesY);
    
    %Back grid
    %Calculate difference between back and front to get proper angle
    diff = thickness;
    adjustmentMin = sqrt((diff/cosd(cornerAngleLeft))^2 - diff^2);
    if isnan(adjustmentMin), adjustmentMin = 0; end
    adjustmentMax = sqrt((diff/cosd(cornerAngleRight))^2 - diff^2);
    if isnan(adjustmentMax), adjustmentMax = 0; end

    %Create back grid (using same number of lines as front atm, maybe change?)
    numberOfLinesBackX = 2;
    numberOfLinesBackY = 2;
    adjustedLeft = leftCorner + adjustmentMin.*wallStruct.sideVector([1 3])' - thickness.*wallStruct.frontVector([1 3])';
    adjustedRight = rightCorner - adjustmentMax.*wallStruct.sideVector([1 3])' - thickness.*wallStruct.frontVector([1 3])';
    backVertices = makeGrid(adjustedLeft, adjustedRight, minY, maxY, numberOfLinesBackX, numberOfLinesBackY);

    %Insert into structure
    wallStruct.vertices = [frontVertices; backVertices];
    
    wallStruct.frontIndices = (1:size(frontVertices,1))';
    wallStruct.gridIndicesFront = customVec2Mat(wallStruct.frontIndices, numberOfLinesX);
    
    wallStruct.backIndices = ((size(frontVertices,1)+1):(size(frontVertices,1)+size(backVertices,1)))';
    wallStruct.gridIndicesBack = customVec2Mat(wallStruct.backIndices, numberOfLinesBackX);
    
    %Save corner indices
    wallStruct.frontCornerIndicesLeft = wallStruct.gridIndicesFront(:,1);
    wallStruct.frontCornerIndicesRight = wallStruct.gridIndicesFront(:,end);
    wallStruct.backCornerIndicesLeft = wallStruct.gridIndicesBack(:,1);
    wallStruct.backCornerIndicesRight = wallStruct.gridIndicesBack(:,end);
    
    %Save top indices
    wallStruct.frontTopIndices = wallStruct.gridIndicesFront(1,:)';
    wallStruct.backTopIndices = wallStruct.gridIndicesBack(1,:)';
end