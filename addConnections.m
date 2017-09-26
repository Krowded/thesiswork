function [foundationStructs, connectionStructs] = addConnections(foundationStructs, connectionStructs, parts)    
    i = 1;
    while i <= length(connectionStructs)
        if isempty(connectionStructs(i).connectedWall)
            i = i+1;
            continue;
        end
        
        for j = 1:length(parts)
            if strcmp(parts{j}.class, connectionStructs(i).class)
                matchingPart = parts{j};
            end
        end
        
        %If no match found, ignore the connection
        if ~exist('matchingPart','var')
            warning(['Did not find any match for part [' char(connectionStructs(i).class) ']. Ignoring connection.'])
            connectionStructs(i) = [];
            continue;
        end
        
        %Parse connection
        connectedWall = connectionStructs(i).connectedWall;
        frontVector = connectionStructs(i).frontVector;
        upVector = connectionStructs(i).upVector;
        if isempty(upVector)
            warning('Connection lacking upVector. Using foundation upVector instead.');
            upVector = foundationStructs(1).upVector;
        end
        if isempty(frontVector)
            warning('Connection lacking frontVector. Using foundation frontVector instead.');
            frontVector = foundationStructs(1).frontVector;
        end
        
        %Match slots
        switch matchingPart.slotType
            case 'default'
                partSlots = (1:size(matchingPart.slots,1)); targetSlots = (1:size(connectionStructs(i).slots,1));
            case 'frontToFront'
                partSlots = 1:4; targetSlots = 1:4;
            case 'backToBack'
                partSlots = 5:8; targetSlots = 5:8;
            case 'frontToBack'
                partSlots = 1:4; targetSlots = 5:8;
            case 'backToFront'
                partSlots = 5:8; targetSlots = 1:4;
            otherwise
                error(['Unknown slot type for adding connection on part ' char(matchingPart.name) ', slotType: ' char(matchingPart.slotType)]);
        end
        M = matchSlots(matchingPart.slots(partSlots,:), connectionStructs(i).slots(targetSlots,:), 'non-uniform', frontVector, upVector);
        
        
        
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