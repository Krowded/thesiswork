function wallStruct = compressWall(wallStruct, distance, direction)
    share = dot(wallStruct.sideVector, direction);
        
    if share < 0 %Left wall
%         indices = [wallStruct.frontCornerIndicesRight; wallStruct.backCornerIndicesRight];
        indices = [wallStruct.gridIndicesFront(:,end); wallStruct.gridIndicesBack(:,end)];
        direction = wallStruct.sideVector;
    else %Right wall
%         indices = [wallStruct.frontCornerIndicesLeft; wallStruct.backCornerIndicesLeft];
        indices = [wallStruct.gridIndicesFront(:,1); wallStruct.gridIndicesBack(:,1)];
        direction = -wallStruct.sideVector;
    end
    
    %Move corner
    compressionVector = abs(share)*distance*direction;
    wallStruct.vertices(indices,:) = wallStruct.vertices(indices,:) + compressionVector;
    
    
    %Check if anything got overlapped by the corner and fix it [POSSIBLY REAL SLOW, FIX LATER]
    sideMostPointAllowed = wallStruct.vertices(indices(1),:)*direction';
    for i = 1:size(wallStruct.vertices,1)
        position = wallStruct.vertices(i,:)*direction';
        if position > sideMostPointAllowed
            wallStruct.vertices(i,:) = wallStruct.vertices(i,:) - position*direction + sideMostPointAllowed*direction;
        end
    end
end