function slotVertices = slotsFromRoofFoundationIntersection(roofVertices, foundationVertices, normal, up)
    zaxis = normal;
    yaxis = up;
    xaxis = normalize(cross(up,normal));

    roofHeights = roofVertices*yaxis';
    foundationHeights = foundationVertices*yaxis';
    
    foundationHighestPoint = max(foundationHeights);
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
    minX = min(x);
    maxX = max(x);
    minZ = min(z);
    maxZ = max(z);
    
    %Preallocate
    slotVertices = zeros(8,3);
    
    %Back slots
    slotVertices(1,:) = minX*xaxis + maxZ*zaxis;
    slotVertices(2,:) = maxX*xaxis + maxZ*zaxis;
    slotVertices(3,:) = maxX*xaxis + maxZ*zaxis;
    slotVertices(4,:) = minX*xaxis + maxZ*zaxis;
    slotVertices(1:2,:) = slotVertices(1:2,:) + foundationHighestPoint*yaxis;
    slotVertices(3:4,:) = slotVertices(3:4,:) + roofLowestPoint*yaxis;
    
    %Front slots
    slotVertices(5,:) = minX*xaxis + minZ*zaxis;
    slotVertices(6,:) = maxX*xaxis + minZ*zaxis;
    slotVertices(7,:) = maxX*xaxis + minZ*zaxis;
    slotVertices(8,:) = minX*xaxis + minZ*zaxis;
    slotVertices(5:6,:) = slotVertices(5:6,:) + foundationHighestPoint*yaxis;
    slotVertices(7:8,:) = slotVertices(7:8,:) + roofLowestPoint*yaxis;
end