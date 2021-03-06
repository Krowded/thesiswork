function slots = slotsFromRoofFoundationIntersection(roofStruct, foundationStructs)
    %Collect all vertices in one array
    foundationVertices = [];
    for i = 1:length(foundationStructs)
        foundationVertices = [foundationVertices; foundationStructs(i).vertices];
    end

    zaxis = foundationStructs(1).frontVector;
    yaxis = foundationStructs(1).upVector;
    xaxis = normalize(cross(yaxis,zaxis));

    %Limit foundationPoints to within the bottom part of roof
    roofHeights = roofStruct.vertices*yaxis';
    foundationHeights = foundationVertices*yaxis';
    roofHighestPoint = max(roofHeights);
    roofLowestPoint = min(roofHeights);
    margin = 0.0001;
    heightLimit = roofLowestPoint - margin;
    foundationPoints = foundationVertices(foundationHeights > heightLimit,:);
    foundationHeights = foundationPoints*yaxis';
    
    %Limit to roofPoints within foundation
    ylimitMin = min(foundationHeights) - margin;
    ylimitMax = max(foundationHeights) + margin;
    roofPoints = roofStruct.vertices(roofHeights > ylimitMin & roofHeights < ylimitMax ,:);
    
    foundationx = foundationPoints*xaxis';
    roofx = roofPoints*xaxis';
    xlimitMin = min(foundationx) - margin;
    xlimitMax = max(foundationx) + margin;
    roofPoints = roofPoints(roofx > xlimitMin & roofx < xlimitMax ,:);
    
    foundationz = foundationPoints*zaxis';
    roofz = roofPoints*zaxis';
    zlimitMin = min(foundationz) - margin;
    zlimitMax = max(foundationz) + margin;
    roofPoints = roofPoints(roofz > zlimitMin & roofz < zlimitMax ,:);
    
%     %Keep only vertices that actually connect
%     connectingPoints = nan(size(foundationPoints));
%     for i = 1:size(foundationPoints,1)
%         for j = 1:size(roofPoints,1)
%             if norm(foundationPoints(i,:) - roofPoints) < 0.01
%                 connectingPoints(i,:) = foundationPoints(i,:);
%                 break;
%             end
%         end
%     end
%     connectingPoints = connectingPoints(~any(isnan(connectingPoints),2),:);

    connectingPoints = roofPoints;

    %Sanity check
    numPoints = size(connectingPoints,1);
    if numPoints < 2
        warning('No immediate connecting points. Extending search');
        connectingPoints = foundationPoints;
        numPoints = size(connectingPoints,1);
        if numPoints < 2
            error(['No valid roof/foundation intersection found. Found ' num2str(numPoints) ' intersecting vertices']);
        end
    end
    
    %Get vertices from contour
    contour = extractContour3D(connectingPoints, yaxis);  
    slotVertices = slotsFromContour(contour, yaxis, zaxis);
    
    %Duplicate and adjust height
    slots = zeros(8,3);
    slots(1:4,:) = slotVertices - (slotVertices*yaxis')*yaxis + roofLowestPoint*yaxis;
    slots(5:8,:) = slotVertices - (slotVertices*yaxis')*yaxis + roofHighestPoint*yaxis;
end