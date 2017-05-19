function wallStruct = compressWall(wallStruct, distance, direction)
    share = dot(wallStruct.sideVector, direction);
        
    if share < 0 %Left wall
        indices = [wallStruct.frontCornerIndicesRight; wallStruct.backCornerIndicesRight];
        direction = wallStruct.sideVector;
    else %Right wall
        indices = [wallStruct.frontCornerIndicesLeft; wallStruct.backCornerIndicesLeft];
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