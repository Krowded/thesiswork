function connection = createChimneyConnection(roofSlots, chimneyWidth, chimneyHeight, numSlots)
    if numSlots ~= 8
        error('Only 8 slots allowed for chimney atm');
    end
    
    %Y
    y = [0 1 0];
    minY = roofSlots(1,2) * y;
    maxY = minY + chimneyHeight * y;
    
    %X
    roofVector1 = normalize(roofSlots(2,:) - roofSlots(1,:));
    max1 = norm(roofSlots(2,:) - roofSlots(1,:)) - chimneyWidth;
    fuzz = rand()*max1;
    pos11 = (roofSlots(1,:)*roofVector1' + fuzz)*roofVector1;
    pos12 = pos11 + chimneyWidth*roofVector1;
    
    %Z
    roofVector2 = normalize(roofSlots(4,:) - roofSlots(1,:));
    max2 = norm(roofSlots(4,:) - roofSlots(1,:)) - chimneyWidth;
    fuzz = rand()*max2;
    pos21 = (roofSlots(1,:)*roofVector2' + fuzz)*roofVector2;
    pos22 = pos21 + chimneyWidth*roofVector2;
    
    %Combine
    slots = [pos11 + maxY + pos22;
             pos12 + maxY + pos22;
             pos12 + minY + pos22;
             pos11 + minY + pos22;
             pos11 + maxY + pos21;
             pos12 + maxY + pos21;
             pos12 + minY + pos21;
             pos11 + minY + pos21];
         
    %Create connection
    connection = newConnectionStruct();
    connection.name = 'chimney';
    connection.connectedWall = 0;
    connection.slots = slots;
    connection.type = 'nocut';
    connection.transformationMatrix = [];
end