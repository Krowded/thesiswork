function connectionStruct = newConnectionStruct()
    connectionStruct = struct();
    connectionStruct.name = '';
    connectionStruct.connectedWall  = 0;
    connectionStruct.slots = [];
    connectionStruct.type = '';
    connectionStruct.transformationMatrix = [];
end