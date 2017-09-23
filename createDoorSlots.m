function slots = createDoorSlots(wallModel, doorWidth, doorHeight, numSlots)
    if nargin < 4
        numSlots = 4;
    end
    
    x = wallModel.sideVector;
    y = wallModel.upVector;
    z = wallModel.frontVector;
    
    xpositions = wallModel.vertices*x';
    maxX = max(xpositions);
    minX = min(xpositions);
    wallWidth = abs(maxX - minX);
    if wallWidth * (7/8)  < doorWidth
        warning('Wall too small for door');
        slots = [];
        return;
    end

    maxAddX = maxX - minX - 2*doorWidth; 
    xpos1 = maxAddX*rand() + minX;
    xpos2 = xpos1 + doorWidth;
    
    minY = min(wallModel.vertices*y'); %Always at ground level
    ypos1 = minY;
    ypos2 = ypos1 + doorHeight;
    
    zpositions = wallModel.vertices*z';
    maxZ = max(zpositions);
    minZ = min(zpositions);
    
    slots = [xpos1*x + ypos2*y + maxZ*z;
             xpos2*x + ypos2*y + maxZ*z;
             xpos2*x + ypos1*y + maxZ*z;
             xpos1*x + ypos1*y + maxZ*z;
             xpos1*x + ypos2*y + minZ*z;
             xpos2*x + ypos2*y + minZ*z;
             xpos2*x + ypos1*y + minZ*z;
             xpos1*x + ypos1*y + minZ*z];
         
    slots = slots(1:numSlots,:);
end