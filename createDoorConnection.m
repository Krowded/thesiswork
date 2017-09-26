function connection = createDoorConnection(wallStructs, wallNumber, doorWidth, doorHeight)
    slots = createDoorSlots(wallStructs(wallNumber), doorWidth, doorHeight, 4);
    if isempty(slots)
        connection = [];
        return;
    end

    connection = newConnectionStruct();
    connection.name = 'door';
    connection.class = 'door';
    connection.connectedWall = wallNumber;
    connection.slots = slots;
    connection.type = 'cut';
    connection.transformationMatrix = [];
    connection.frontVector = wallStructs(wallNumber).frontVector;
    connection.upVector = wallStructs(wallNumber).upVector;
end