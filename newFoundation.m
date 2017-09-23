function [foundationStructs, connections] = newFoundation()
    %Make a new foundation
    numberOfWalls = 4;%2*randi([2 4],1);
    radius = 40000;
    height = 60000;
    wallThickness = 4000;
    [foundationStructs, topCorners] = buildAnySidedFoundation(numberOfWalls, radius, height, wallThickness);

    % Add roof slots
    roofHeight = height;

   %Longest walls version
%     foundationStructs(1).slots = corners;
%     foundationStructs(1).slots(5:8,:) = corners + [0 1 0]*roofHeight;

    %Extreme points version
    forward = foundationStructs(1).frontVector;
    up = foundationStructs(1).upVector;
    side = normalize(fastCross(forward, up));
    v = mergeModels(foundationStructs);
    x = v.vertices*side';
    z = v.vertices*forward';
    maxX = max(x);
    minX = min(x);
    maxZ = max(z);
    minZ = min(z);
    corners = [maxX height maxZ;
               minX height maxZ;
               minX height minZ;
               maxX height minZ];
    corners = [corners; corners + up*roofHeight];
    foundationStructs(1).slots = corners;
    
    %Add connections
    %Door
    n = randi([1 numberOfWalls]);
    doorHeight = height/2;
    doorWidth = doorHeight/1.6;
    connections = createDoorConnection(foundationStructs, n, doorWidth, doorHeight);

    %Windows
    windowHeight = height/3;
    windowWidth = height/3;
    connection = createWindowConnections(foundationStructs, windowWidth, windowHeight, connections);
    if ~isempty(connection)
        if ~isempty(connections)
            connections = [connections connection];
        else
            connections = connection;
        end
    end
    

%     %Chimney
%     chimneyHeight = height/3;
%     chimneyWidth = height/4;
%     connection = createChimneyConnection(foundationStructs(1).slots, chimneyWidth, chimneyHeight, 8);
%     if ~isempty(connection)
%         if ~isempty(connections)
%             connections = [connections connection];
%         else
%             connections = connection;
%         end
%     end
end