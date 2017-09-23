function [slots, updatedNumberOfWindows] = createWindowSlots(wallModel, numberOfWindows, windowWidth, windowHeight, numSlots)
    if nargin < 5
        numSlots = 4;
    end
    slots = [];
    
    distanceBetweenWindows = rand()*(windowWidth);
    
    x = wallModel.sideVector;
    y = wallModel.upVector;
    z = wallModel.frontVector;
    
    xpositions = wallModel.vertices*x';
    maxX = max(xpositions);
    minX = min(xpositions);
    
    ypositions = wallModel.vertices*y';
    minY = min(ypositions);
    maxY = max(ypositions);
    
    minY = minY + (maxY-minY)/2 - windowHeight/2; %Windows have their lowest point in the middle
    maxAddY = (maxY - minY)/2 - windowHeight; %Not above the edge, obviously
    ypos1 = maxAddY*rand() + minY;
    ypos2 = ypos1 + windowHeight;
    
    zpositions = wallModel.vertices*z';
    maxZ = max(zpositions);
    minZ = min(zpositions);
    
    while numberOfWindows*windowWidth + (numberOfWindows+1)*distanceBetweenWindows > (maxX-minX)
        numberOfWindows = numberOfWindows - 1;
    end
    
    xStartMax = maxX - numberOfWindows*windowWidth - (numberOfWindows+1)*distanceBetweenWindows;
    xstart = rand()*(xStartMax-minX) + minX + distanceBetweenWindows;
    xadd = windowWidth + distanceBetweenWindows;
    for i = 1:numberOfWindows
        xpos1 = xstart + (i-1)*xadd;
        xpos2 = xpos1 + windowWidth;
        
        tempSlots = [xpos1*x + ypos2*y + maxZ*z;
                     xpos2*x + ypos2*y + maxZ*z;
                     xpos2*x + ypos1*y + maxZ*z;
                     xpos1*x + ypos1*y + maxZ*z;
                     xpos1*x + ypos2*y + minZ*z;
                     xpos2*x + ypos2*y + minZ*z;
                     xpos2*x + ypos1*y + minZ*z;
                     xpos1*x + ypos1*y + minZ*z];
        tempSlots = tempSlots(1:numSlots,:);
        slots((end+1):(end+numSlots),:) = tempSlots;
    end
   
    updatedNumberOfWindows = numberOfWindows;
end