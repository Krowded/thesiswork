function curveVertices = getCurveVertices(vertices, zdirection, ydirection)
    vertices = changeBasis(vertices, zdirection, ydirection);
    flattenedVertices = vertices(:,1:2);
    shapeVertices = flattenedVertices(boundary(flattenedVertices(:,1), flattenedVertices(:,2), 0.90), :);
    
    if isempty(shapeVertices)
        warning('Found no shape around vertices. Assuming curve is straight line.')
        curveVertices = [0 0; 0 1];
        return;
    end


    %Using some configuration of alpha shapes might be better. For now,
    %boundary is fine
%     shape = alphaShape(flattenedVertices(:,1), flattenedVertices(:,2));
%     flattenedVertices = shape.Points;

    %Since flattened vertices are in winding order, we can just check the
    %sign of the vector between two consecutive points
    curveVertices = [];
    lastOneAdded = 0; %Keep track of if we are in a chain of adding, otherwise we need to add current vertex as well
    addedIndices = [];
   
    for j = 1:(size(shapeVertices,1)-1)
        edge = shapeVertices(j+1,:) - shapeVertices(j,:);
        if edge(2) > 0
            if ~lastOneAdded
                curveVertices(end+1,:) = shapeVertices(j,:);
                addedIndices(end+1) = j;
            end
            curveVertices(end+1,:) = shapeVertices(j+1,:);
            addedIndices(end+1) = j+1;
            lastOneAdded = 1;
        else
            lastOneAdded = 0;
        end
    end
    
    %Finish loop by checking connection between first and last index
    lastIndex = size(shapeVertices,1);
    edge = shapeVertices(1,:) - shapeVertices(lastIndex,:);
    if edge(2) > 0
        if ~ismember(lastIndex, addedIndices)
            curveVertices(end+1,:) = shapeVertices(lastIndex,:);
        end
        
        if ~ismember(1, addedIndices)
            curveVertices(end+1,:) = shapeVertices(1,:);
        end
    end
    
    %Shift array so that it starts with the lowest point
    notDone = 1;
    k = 1;
    current = curveVertices(1,2);
    L = size(curveVertices,1);
    while notDone
        if curveVertices(k+1, 2) < current
            curveVertices = customCircShift(curveVertices, k);
            current = curveVertices(1,2);
            k = 1;
        else
            k = k+1;
        end
        
        if k+1 > L
            notDone = false;
        end
    end
    
    %Remove all points lost behind lowest and highest points
    highestPoint = max(curveVertices(:,2)) - 0.00001;
    while curveVertices(end,2) < highestPoint
        curveVertices(end,:) = [];
    end    
    
    %Remove any conflicting X values, keeping the larger one (i.e. the one
    %closer to the edge)
    curveVertices = removeDuplicates1D(curveVertices, [0 1], [1 0]);
    curveVertices = removeRedundantVertices(curveVertices);
    
    %Top and bottom tend to have leftovers from the contour. Weed them out.
    curveVertices = removeTails(curveVertices);

    function vertices = removeTails(vertices)
        %Skip if too small to have a tail
        if size(vertices,1) < 3
            return;
        end
        
        %Remove tail from the bottom
        tenth = (vertices(end,2) - vertices(1,2)) / 10;
        maxPoint = vertices(1,2) + tenth;
        i = 1;
        while vertices(i+1,2) < maxPoint
            v1 = normalize(vertices(i+1,:) - vertices(i,:));
            v2 = normalize(vertices(i+2,:) - vertices(i+1,:));
            
            angle = atan2d(norm(cross([v1 0], [v2 0])),dot(v1,v2));
            
            if angle > 45 %Bigger than 45 degrees seems to be unintentional - break off anyhing before this
                vertices(1:i,:) = [];
                i = 1;
                continue;
            end
            i = i+1;
        end
        
        %Remove tail from the top
        tenth = (vertices(end,2) - vertices(1,2)) / 10;
        minPoint = vertices(end,2) - tenth;
        i = size(vertices,1);
        while vertices(i-1,2) > minPoint
            v1 = normalize(vertices(i-1,:) - vertices(i,:));
            v2 = normalize(vertices(i-2,:) - vertices(i-1,:));
            
            angle = atan2d(norm(cross([v1 0], [v2 0])),dot(v1,v2));
            
            if angle > 45 %Bigger than 45 degrees seems to be unintentional - break off anyhing before this
                vertices(i:end,:) = [];
                i = size(vertices,1);
                continue;
            end
            i = i-1;
        end
    end
end