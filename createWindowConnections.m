function connections = createWindowConnections(wallStructs, windowWidth, windowHeight, otherConnections)
    connections = newConnectionStruct();
    skip = 0;
    
    for wallNumber = 1:length(wallStructs)
        %Need to avoid collision with previous connections
        pointsToAvoid = [];
        for j = 1:length(otherConnections)
            if any(otherConnections(j).connectedWall == wallNumber)
                pos = otherConnections(j).slots*wallStructs(wallNumber).sideVector';
                minp = min(pos);
                maxp = max(pos);
                pointsToAvoid(end+1,:) = [minp maxp];
            end
        end
        
        %Create a random number of windows on this wall
        numberOfWindows = [0 2 3 4 5];
        numberOfWindows = numberOfWindows(randi([1 4]));
        if numberOfWindows == 0
            continue;
        end
        
        numSlots = 4;
        [slots, numberOfWindows] = createWindowSlots(wallStructs(wallNumber), numberOfWindows, windowWidth, windowHeight, numSlots);        
        
        for j = 1:numberOfWindows
            tempSlots = slots(((j-1)*numSlots + 1):j*numSlots,:);
            
            %Simple solution: Skip any overlapping slots
            if ~isempty(pointsToAvoid)
                xpos = tempSlots*wallStructs(wallNumber).sideVector';
                if any( xpos > pointsToAvoid(:,1) & xpos < pointsToAvoid(:,2) )
                    continue;
                end
            end
            
            connection = newConnectionStruct();
            num = randi([1 2]);
            switch num
                case 1
                    connection.name = 'bigWindow';
                    connection.class = 'bigWindow';
                    connection.type = 'nocut';
                case 2
                    connection.name = 'smallWindow';
                    connection.class = 'bigWindow';
                    connection.type = 'cut';
            end
            connection.connectedWall = wallNumber;
            connection.slots = tempSlots;
            connection.transformationMatrix = [];
            connection.frontVector = wallStructs(wallNumber).frontVector;
            connection.upVector = wallStructs(wallNumber).upVector;
            
            connections(end+1) = connection;
        end
    end
    
    connections = connections(2:end); %Remove empty first connection (workaround)
end