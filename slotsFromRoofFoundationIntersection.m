function slots = slotsFromRoofFoundationIntersection(roofStruct, foundationStructs)
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
    
    %Get vertices from contour
    contour = extractContour3D(foundationPointsAboveLimit, yaxis);
    slotVertices = slotsFromContour(contour, yaxis, zaxis);
    
    %Duplicate and adjust height
    slots = zeros(8,3);
    slots(1:4,:) = slotVertices - (slotVertices*yaxis')*yaxis + roofLowestPoint*yaxis;
    slots(5:8,:) = slotVertices - (slotVertices*yaxis')*yaxis + roofHighestPoint*yaxis;
end