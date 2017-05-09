function [foundationStructs, holeStructs, transformationMatrices] = addConnections(foundationStructs, connectionStructs, parts)
    holeStructs = newHoleStruct(1,1);
    transformationMatrices = cell(length(connectionStructs),1);
    
    for i = 1:length(connectionStructs)
        for j = 1:length(parts)
            if strcmp(parts{j}.name, connectionStructs(1).name)
                part = parts{j};
            end
        end
        
        %Parse connection
        connection = connectionStructs(i);
        doorSlots = connection.slots;
        connectedWall = connection.connectedWall;

        %Match slots
        M = matchSlots(part.slots, doorSlots, 'uniform');

        %Get contour and move to wall
        newModelContour = part.contour;
        newModelContour = applyTransformation(newModelContour, M);

        %Constrain contour
        T = constrainContour(foundationStructs(connectedWall).vertices, newModelContour, foundationStructs(connectedWall).upVector);
        newModelContour = applyTransformation(newModelContour, T);
        M = T*M;

        %Carve door shape into front wall
        [foundationStructs(connectedWall), holeStruct] = createHoleFromContour(foundationStructs(connectedWall), newModelContour);
        holeStruct.connectedWall = connectedWall;

        %Collect output parameters
        holeStructs(i) = holeStruct;
        transformationMatrices{i} = M;
    end
end