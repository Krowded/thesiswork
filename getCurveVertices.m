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
    
    %Top and bottom tend to have leftovers from the contour. Weed them out.    
    curveVertices = removeTail(curveVertices, 'ascend');
    curveVertices = removeTail(curveVertices, 'descend');
    
    %Remove any conflicting X values, keeping the larger one (i.e. the one
    %closer to the edge)
    curveVertices = removeDuplicates1D(curveVertices, [0 1], [1 0]);
    
    function vertices = removeTail(vertices, direction)
        [~, I] = sort(vertices(:,2), 1, direction);
        granularity = 100;

        startingIndex = I(1);
        minHeight = vertices(startingIndex,2);
        distanceToCheck = abs(vertices(I(1),2) - vertices(I(end),2))/granularity;
        maxX = vertices(I(1),1);
        
        indicesToReduce = [];
        for k = 2:length(I)
            index = I(k);
            
            if abs(minHeight - vertices(index,2)) < distanceToCheck
                indicesToReduce(end+1) = index;
                maxX = max(maxX, vertices(index,1));
            else
                break;
            end
        end
        
        vertices(startingIndex,1) = maxX;
        vertices(indicesToReduce,:) = [];
    end
end