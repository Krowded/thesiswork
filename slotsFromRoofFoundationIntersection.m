function slotVertices = slotsFromRoofFoundationIntersection(roofStruct, foundationStructs)
    %Collect all vertices in one array
    foundationVertices = [];
    for i = 1:length(foundationStructs)
        foundationVertices = [foundationVertices; foundationStructs(i).vertices];
    end

    zaxis = foundationStructs(1).frontNormal;
    yaxis = foundationStructs(1).upVector;
    xaxis = normalize(cross(yaxis,zaxis));

    roofHeights = roofStruct.vertices*yaxis';
    foundationHeights = foundationVertices*yaxis';
    
    %foundationHighestPoint = max(foundationHeights);
    roofHighestPoint = max(roofHeights);
    roofLowestPoint = min(roofHeights);
    margin = 0.001;
    heightLimit = roofLowestPoint - margin;
    foundationPointsAboveLimit = foundationVertices(foundationHeights > heightLimit,:);
    
    %Sanity check
    if isempty(foundationPointsAboveLimit)
        error('No roof/foundation intersection found');
    end
    
    %Corner values
    x = foundationPointsAboveLimit*xaxis';
    z = foundationPointsAboveLimit*zaxis';
    margin = 0.1;
    warning('having a hardcoded margin is weird')
    minX = min(x) - margin;
    maxX = max(x) + margin;
    minZ = min(z) - margin;
    maxZ = max(z) + margin;
    
    %Preallocate
    slotVertices = zeros(8,3);
    
    %Back slots
    slotVertices(1,:) = minX*xaxis + maxZ*zaxis;
    slotVertices(2,:) = maxX*xaxis + maxZ*zaxis;
    slotVertices(3,:) = maxX*xaxis + maxZ*zaxis;
    slotVertices(4,:) = minX*xaxis + maxZ*zaxis;
    slotVertices(1:2,:) = slotVertices(1:2,:) + roofHighestPoint*yaxis;
    slotVertices(3:4,:) = slotVertices(3:4,:) + roofLowestPoint*yaxis;
    
    %Front slots
    slotVertices(5,:) = minX*xaxis + minZ*zaxis;
    slotVertices(6,:) = maxX*xaxis + minZ*zaxis;
    slotVertices(7,:) = maxX*xaxis + minZ*zaxis;
    slotVertices(8,:) = minX*xaxis + minZ*zaxis;
    slotVertices(5:6,:) = slotVertices(5:6,:) + roofHighestPoint*yaxis;
    slotVertices(7:8,:) = slotVertices(7:8,:) + roofLowestPoint*yaxis;
end