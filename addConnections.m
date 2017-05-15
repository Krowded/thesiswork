function [foundationStructs, connectionStructs] = addConnections(foundationStructs, connectionStructs, parts)    
    i = 1;
    while i <= length(connectionStructs)
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
        frontVector = connectionStructs(i).frontVector;
        upVector = connectionStructs(i).upVector;
        
        %Match slots
        M = matchSlots(matchingPart.slots, connectionStructs(i).slots, 'non-uniform', frontVector, upVector);

        if strcmp(connectionStructs(i).type, 'cut')
            %Get contour and move to wall
            newModelContour = matchingPart.contour;
            newModelContour = applyTransformation(newModelContour, M);

            %Constrain contour
            T = constrainContour(foundationStructs(connectedWall).vertices, newModelContour, upVector);
            newModelContour = applyTransformation(newModelContour, T);
            M = T*M;

            %Carve shape into wall
            [foundationStructs(connectedWall), connectionStructs(i).holeStruct] = createHoleFromContour(foundationStructs(connectedWall), newModelContour);
        end

        %Collect output parameters
        connectionStructs(i).transformationMatrix = M;
        
        i = i+1;
    end
end