%Returns the curve vertices of a wallStruct, scaled so that the bottom one
%is at 0 and top one is at 100
function curveStruct = getWallCurve(wallStruct)
    sideVector = normalize(cross(wallStruct.upVector, wallStruct.frontNormal));
    vertices = wallStruct.vertices;
    vertices = getTopPercentOfPoints(vertices, sideVector, 10);
    
    vertices = changeBasis(vertices, sideVector, wallStruct.upVector, wallStruct.frontNormal);

    flattenedVertices = vertices(:,1:2);
    flattenedVertices = flattenedVertices(boundary(flattenedVertices(:,1), flattenedVertices(:,2), 0.9), :);
    
    %Since flattened vertices are in winding order, we can just check if the vector
    %between two consecutive points are positive in the y direction to get
    %one side of wall
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
    
    %Normalize so the highest point is at 100 and the lowest at 0
    [maxY, i] = max(curveVertices(:,2));
    minY = min(curveVertices(:,2));
    %minX = min(curveVertices(:,1));
    minX = curveVertices(i,1); %We want top vertex stationary later on
    normalizer = 100/(maxY-minY);
    curveVertices(:,2) = (curveVertices(:,2) - minY).*normalizer;
    curveVertices(:,1) = (curveVertices(:,1) - minX).*normalizer; %Same scale, different cutoff
    
    %Make return struct
    curveStruct.vertices = curveVertices;
    curveStruct.curveFunction = @(xq) interp1(curveVertices(:,2), curveVertices(:,1), xq, 'linear', 'extrap');
    curveStruct.curveLength = size(curveVertices);
    curveStruct.span = max(curveVertices(:,1) - min(curveVertices(:,1)));
    
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