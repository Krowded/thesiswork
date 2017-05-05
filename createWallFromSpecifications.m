function wallStruct = createWallFromSpecifications(minWidth, maxWidth, minHeight, maxHeight, minDepth, maxDepth, normal, up, numberOfLinesX, numberOfLinesY, angleLeft, angleRight)
    %Setup
    wallStruct = newModelStruct();
    
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
    
%   Back can just be a simple square (for now)
    backVertices = [ adjustedMinWidth minHeight minDepth;
                     adjustedMinWidth maxHeight minDepth;
                     adjustedMaxWidth maxHeight minDepth;
                     adjustedMaxWidth minHeight minDepth ];
     
    %Front is a full grid
    frontVertices = zeros(numberOfLinesX*numberOfLinesY, 3);
    frontVertices(:,3) = maxDepth;
    for i = 1:numberOfLinesX
        frontVertices(((i-1)*numberOfLinesY+1):(i*numberOfLinesY), 1) = minWidth + (i-1)*distanceBetweenLinesX;
    end

    for i = 1:numberOfLinesY
        frontVertices(i:numberOfLinesY:size(frontVertices,1), 2) = minHeight + (i-1)*distanceBetweenLinesY;
    end
    
    %Save corner indices for curving later
    wallStruct.cornerIndicesLeft = 1:numberOfLinesY;
    wallStruct.cornerIndicesRight = ((numberOfLinesX-1)*numberOfLinesY+1):(numberOfLinesX*numberOfLinesY);
     
    %Insert into structure
    wallStruct.frontIndices = (1:size(frontVertices,1))';
    wallStruct.backIndices = ((size(frontVertices,1)+1):(size(frontVertices,1)+size(backVertices,1)))';
    wallStruct.vertices = [frontVertices; backVertices];
    
    %Rotate to fit basis
    z = normal;
    y = up;
    x = normalize(cross(y, z));
    wallStruct.vertices = changeBasis(wallStruct.vertices, z, y, x);
    
    %Don't know why I have to do it this way, but it seems to fix the
    %problem..
    wallStruct.frontNormal = changeBasis([0, 0, 1], z, y, x);
    wallStruct.upVector = changeBasis([0, 1, 0], z, y, x);
    
end