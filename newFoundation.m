function [foundationStructs, connections] = newFoundation()
    %Make a new foundation
    numberOfWalls = 4;
    radius = 40000;
    height = 60000;
    wallThickness = 4000;
    foundationStructs = buildAnySidedFoundation(numberOfWalls, radius, height, wallThickness);

    % % Add roof positioning slots
    foundationStructs(1).slots = [-radius, height,  radius;
                                  -radius, height, -radius;
                                   radius, height, -radius;
                                   radius, height,  radius];
%     foundationStructs(1).slots = (4/5)*foundationStructs(1).slots;
                               
    
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
    slots = [minX maxY maxZ;
             maxX maxY maxZ;
             maxX minY maxZ;
             minX minY maxZ];
%              minX maxY minZ;
%              maxX maxY minZ;
%              maxX minY minZ;
%              minX minY minZ];
             
    connection = newConnectionStruct();
    connection.name = 'door';
    connection.connectedWall  = 1;
    connection.slots = slots;
    connection.type = 'cut';
    connection.transformationMatrix = [];
    connection.frontVector = foundationStructs(1).frontVector;
    connection.upVector = foundationStructs(1).upVector;
    
    connections(1) = connection;
    

    %Adding chimney (lazy way)
    maxY = minY + 2*(maxY-minY);
    maxX = minX + 2*(maxX-minX);
    maxZ = minZ + 2*(maxZ-minZ);
    slots = [minX maxY maxZ;
             maxX maxY maxZ;
             maxX minY maxZ;
             minX minY maxZ;
             minX maxY minZ;
             maxX maxY minZ;
             maxX minY minZ;
             minX minY minZ];
%     angle = -pi/2;
%     r = [cos(angle), 0, sin(angle), 0;
%          0, 1, 0, 0;
%          -sin(angle), 0, cos(angle), 0;
%          0, 0, 0, 1];
    t = height*[0 1 0] - (radius/2)*[0 0 1];
    t = getTranslationMatrixFromVector(t);
    slots = applyTransformation(slots, t);
     
    connection = newConnectionStruct();
    connection.name = 'chimney';
    connection.connectedWall  = 0;
    connection.slots = slots;
    connection.type = 'nocut';
    connection.transformationMatrix = [];
    connection.frontVector = foundationStructs(1).frontVector;
    connection.upVector = foundationStructs(1).upVector;

    connections(2) = connection;
end