function [foundationStructs, holeStructs, connectionStructs] = addConnections(foundationStructs, connectionStructs, parts)
    holeStructs = newHoleStruct(1,1);
    
    i = 1;
    while i < length(connectionStructs)+1
        for j = 1:length(parts)
            if strcmp(parts{j}.name, connectionStructs(i).name)
                matchingPart = parts{j};
            end
        end
        
        %If no match found, ignore the connection
        if ~exist('matchingPart','var')
            warning(['Did not find any match for part [' char(connectionStructs(i).name) ']. Ignoring connection.'])
            connectionStructs(i) = [];
            continue;
        end
        
        
        %Parse connection
        connectedWall = connectionStructs(i).connectedWall;
        
        %Match slots
        M = matchSlots(matchingPart.slots, connectionStructs(i).slots, 'uniform');

        if strcmp(connectionStructs(i).type, 'cut')
            %Get contour and move to wall
            newModelContour = matchingPart.contour;
            newModelContour = applyTransformation(newModelContour, M);

            %Constrain contour
            T = constrainContour(foundationStructs(connectedWall).vertices, newModelContour, foundationStructs(connectedWall).upVector);
            newModelContour = applyTransformation(newModelContour, T);
            M = T*M;

            %Carve door shape into wall
            [foundationStructs(connectedWall), holeStruct] = createHoleFromContour(foundationStructs(connectedWall), newModelContour);
            holeStruct.connectedWall = connectedWall;
        else
            holeStruct = newHoleStruct();
        end

        %Collect output parameters
        holeStructs(i) = holeStruct;
        connectionStructs(i).transformationMatrix = M;
        
        i = i+1;
    end
end