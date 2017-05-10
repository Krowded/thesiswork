function [foundationStructs, connections] = newFoundation()
    %Make a new foundation
    numberOfWalls = 8;
    radius = 40000;
    height = 60000;
    wallThickness = 10;%
    foundationStructs = buildAnySidedFoundation(numberOfWalls, radius, height, wallThickness);

    % % Add roof positioning slots
    foundationStructs(1).slots = [-radius, height,  radius;
                                  -radius, height, -radius;
                                   radius, height, -radius;
                                   radius, height,  radius];
                               
    
    %Add connections
    %Create door positioning slots
    x = [1, 0, 0];
    y = [0, 1, 0];
    z = [0, 0, 1];
    temp = foundationStructs(1).vertices;
    maxX = max(temp*x');
    minX = min(temp*x');
    diff = abs(maxX - minX);
    maxX = 5*diff/20 + minX;
    minX = 4*diff/20 + minX;
    maxY = max(temp*y');
    minY = min(temp*y');
    diff = abs(maxY - minY);
    maxY = diff/5 + minY;
    maxZ = max(temp*z');
    minZ = min(temp*z');
    doorSlots = [minX maxY maxZ;
                 maxX maxY maxZ;
                 maxX minY maxZ;
                 minX minY maxZ;
                 minX maxY minZ;
                 maxX maxY minZ;
                 maxX minY minZ;
                 minX minY minZ];
             
    connection = struct();
    connection.name = 'door';
    connection.connectedWall  = 1;
    connection.slots = doorSlots;
    connection.type = 'cut';
    connection.transformationMatrix = [];

    connections(1) = connection;
end