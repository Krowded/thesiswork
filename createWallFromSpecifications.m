function wallStruct = createWallFromSpecifications(minWidth, maxWidth, minHeight, maxHeight, minDepth, maxDepth, normal, up, numberOfLinesX, numberOfLinesY, angleLeft, angleRight)
    %Setup
    wallStruct = newWallStruct();
    
    densityX = numberOfLinesX - 1;
    densityY = numberOfLinesY - 1;
    distanceBetweenLinesX = (maxWidth - minWidth)/densityX;
    distanceBetweenLinesY = (maxHeight - minHeight)/densityY;
    
    %Calculate difference between back and front to get proper angle
    angleLeft = angleLeft/2; %We want half the angle between the walls
    angleRight = angleRight/2;
    diff = maxDepth - minDepth;
    adjustedMinWidth = minWidth + sqrt((diff/cosd(angleLeft))^2 - diff^2);
    if isnan(adjustedMinWidth), adjustedMinWidth = minWidth; end
    adjustedMaxWidth = maxWidth - sqrt((diff/cosd(angleRight))^2 - diff^2);
    if isnan(adjustedMaxWidth), adjustedMaxWidth = maxWidth; end
    
%   Back can just be a simple square
    numberOfLinesBackX = 2;
    numberOfLinesBackY = 2;
    backVertices = [ adjustedMinWidth maxHeight minDepth;
                     adjustedMaxWidth maxHeight minDepth;
                     adjustedMinWidth minHeight minDepth
                     adjustedMaxWidth minHeight minDepth;];
                 
    %Front is a full grid
    frontVertices = zeros(numberOfLinesX*numberOfLinesY, 3);
    frontVertices(:,3) = maxDepth;
    for i = 1:numberOfLinesY
        frontVertices(((i-1)*numberOfLinesX+1):(i*numberOfLinesX), 2) = minHeight + (numberOfLinesY-i)*distanceBetweenLinesY;
    end
    
    for i = 1:numberOfLinesX
        frontVertices(i:numberOfLinesX:size(frontVertices,1), 1) = minWidth + (i-1)*distanceBetweenLinesX;
    end
    
    %Insert into structure
    wallStruct.vertices = [frontVertices; backVertices];
    
    wallStruct.frontIndices = (1:size(frontVertices,1))';
    wallStruct.gridIndicesFront = customVec2Mat(wallStruct.frontIndices, numberOfLinesX);
    
    wallStruct.backIndices = ((size(frontVertices,1)+1):(size(frontVertices,1)+size(backVertices,1)))';
    wallStruct.gridIndicesBack = customVec2Mat(wallStruct.backIndices, numberOfLinesBackX);
    
%     %Save corner indices for curving purposes
    wallStruct.frontCornerIndicesLeft = wallStruct.gridIndicesFront(:,1);
    wallStruct.frontCornerIndicesRight = wallStruct.gridIndicesFront(:,end);
    wallStruct.backCornerIndicesLeft = wallStruct.gridIndicesBack(:,1);
    wallStruct.backCornerIndicesRight = wallStruct.gridIndicesBack(:,end);
    
    %Save top indices for similar stuff
    wallStruct.frontTopIndices = wallStruct.gridIndicesFront(1,:)';
    wallStruct.backTopIndices = wallStruct.gridIndicesBack(1,:)';
    
    %Rotate to fit basis
    z = normal;
    y = up;
    x = normalize(cross(y, z));
    wallStruct.vertices = changeBasis(wallStruct.vertices, z, y, x);
    
    %Don't know why I have to do this this way, but it seems to make it
    %correct
    wallStruct.frontVector = changeBasis([0, 0, 1], z, y, x);
    wallStruct.upVector = changeBasis([0, 1, 0], z, y, x);
    wallStruct.sideVector = normalize(cross(wallStruct.upVector, wallStruct.frontVector));
end