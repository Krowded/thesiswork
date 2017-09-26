function slots = slotsFromModelIntersection(model1, model2)
    %Bind to orientation of model2
    zaxis = model2.frontVector;
    yaxis = model2.upVector;
    xaxis = normalize(fastCross(yaxis,zaxis));
    
    %Get general direction of intersection
    intersectionDirection = localGetIntersectionDirection(model1.vertices, model2.vertices);
    
    %Flatten y-direction
    if abs(intersectionDirection*yaxis') < 0.5
        intersectionDirection = normalize(intersectionDirection - (intersectionDirection*yaxis')*yaxis);
        zaxis = yaxis;
        yaxis = intersectionDirection;
        xaxis = normalize(fastCross(yaxis, zaxis));
    else
        %Keep axises as they are if intersectionDirection is approx yaxis
    end
    
    
    %Limit model2's points to within the edge of model2 (+ a margin)
    model1Heights = model1.vertices*yaxis';
    model2Heights = model2.vertices*yaxis';
    model1HighestPoint = max(model1Heights);
    model1LowestPoint = min(model1Heights);
    margin = 0.0001;
    heightLimit = model1LowestPoint - margin;
    model2Points = model2.vertices(model2Heights > heightLimit,:);
    model2Heights = model2Points*yaxis';
    
    %Limit to model1 points within model2
    ylimitMin = min(model2Heights) - margin;
    ylimitMax = max(model2Heights) + margin;
    model1Points = model1.vertices(model1Heights > ylimitMin & model1Heights < ylimitMax ,:);
    
    model2x = model2Points*xaxis';
    model1x = model1Points*xaxis';
    xlimitMin = min(model2x) - margin;
    xlimitMax = max(model2x) + margin;
    model1Points = model1Points(model1x > xlimitMin & model1x < xlimitMax ,:);
    
    model2z = model2Points*zaxis';
    model1z = model1Points*zaxis';
    zlimitMin = min(model2z) - margin;
    zlimitMax = max(model2z) + margin;
    model1Points = model1Points(model1z > zlimitMin & model1z < zlimitMax ,:);

    intersectingPoints = model1Points;

    %Sanity check
    numPoints = size(intersectingPoints,1);
    if numPoints < 2
        warning('No immediate connecting points. Extending search');
        intersectingPoints = model2Points;
        numPoints = size(intersectingPoints,1);
        if numPoints < 2
            error(['No valid intersection found. Found ' num2str(numPoints) ' intersecting vertices']);
        end
    end
    
    %Get vertices from contour
    contour = extractContour3D(intersectingPoints, yaxis);
    slotVertices = slotsFromContour(contour, yaxis, zaxis);
    
    %Duplicate and adjust height
    slots = zeros(8,3);
    slots(1:4,:) = slotVertices - (slotVertices*yaxis')*yaxis + model1LowestPoint*yaxis;
    slots(5:8,:) = slotVertices - (slotVertices*yaxis')*yaxis + model1HighestPoint*yaxis;    
    
    function intersectionDirection = localGetIntersectionDirection(vertices1, vertices2)
        y1 = vertices1*yaxis';
        maxY1 = max(y1);
        minY1 = min(y1);
        
        y2 = vertices2*yaxis';
        maxY2 = max(y2);
        minY2 = min(y2);
        
        %If more than half of the model is above the max point, then it's probably an
        %above connection, or if opposite a below one
        if ((maxY1 - minY1)/2 + minY1) > maxY2 
            intersectionDirection = yaxis;
            return;
        elseif ((maxY1 - minY1)/2 + minY1) < minY2
            intersectionDirection = -yaxis;
            return;
        end
        
        %Otherwise, pick a vector from mid point to midpoint and remove yaxis
        mid1 = localGetMidPoint(vertices1);
        mid2 = localGetMidPoint(vertices2);
        intersectionDirection = mid1 - mid2;
        intersectionDirection = normalize(intersectionDirection - (intersectionDirection*yaxis')*yaxis);
    end
    
    function midPoint = localGetMidPoint(vertices)
        x = vertices*xaxis';
        y = vertices*yaxis';
        z = vertices*zaxis';
        
        midX = (max(x) + min(x))/2;
        midY = (max(y) + min(y))/2;
        midZ = (max(z) + min(z))/2;
        
        midPoint = midX*xaxis + midY*yaxis + midZ*zaxis;
    end
end