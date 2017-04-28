function curveVertices = getCurveVertices(vertices, zdirection, ydirection)
    vertices = changeBasis(vertices, zdirection, ydirection);
    flattenedVertices = vertices(:,1:2);
    flattenedVertices = flattenedVertices(boundary(flattenedVertices(:,1), flattenedVertices(:,2), 0.9), :);
    
    %Since flattened vertices are in winding order, we can just check the
    %sign of the vector between two consecutive points
    curveVertices = [];
    for j = 1:(size(flattenedVertices,1)-1)
        edge = flattenedVertices(j+1,:) - flattenedVertices(j,:);
        if edge(2) > 0
            curveVertices(end+1,:) = flattenedVertices(j,:);
        end
    end
    
    %Last one
    edge = flattenedVertices(1,:) - flattenedVertices(end,:);
    if edge(2) > 0
        curveVertices(end+1) = flattenedVertices(1,:);
    end
    
    %Top and bottom tend to have leftovers from the contour. Weed them out.
    curveVertices = removeTail(curveVertices, 'ascend');
    curveVertices = removeTail(curveVertices, 'descend');
    
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