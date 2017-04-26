function vertices = fitModelToCurve(vertices, curve, xdirection, ydirection, minNumberOfPoints)
    if nargin < 5
        minNumberOfPoints = -Inf;
    end
    
    %If too few points, add more
    if size(vertices,1) < minNumberOfPoints
        x = vertices*xdirection';
        [x,indices] = sort(x);
        totalDistance = abs(x(1)-x(end));
        averageDistanceBetweenPoints = totalDistance/minNumberOfPoints;
        
        %Preallocate
        newVertices = zeros(minNumberOfPoints,3);
        newVertices(1,:) = vertices(indices(1),:);

        i = 2;
        j = 2;
        while i < length(x)+1
            lastX = newVertices(j-1,:)*xdirection';
            nextX = x(i);
            if abs(nextX - lastX) < averageDistanceBetweenPoints
                newVertices(j,:) = vertices(indices(i),:);
                i = i + 1;
            else
                direction = normalize(vertices(indices(i),:) - newVertices(j-1,:));
                projection = dot(direction, xdirection);
                distance = averageDistanceBetweenPoints/projection;
                newVertices(j,:) = newVertices(j-1,:) + direction.*distance;
            end
            j = j + 1;
        end
        
        vertices = newVertices;
    end

    %Adjust vertex height according to curve
    for i = 1:size(vertices,1)
        x = vertices(i,:)*xdirection';
        y = curve(x);
        
        if ~isnan(y)
            vertices(i,:) = vertices(i,:) - ydirection*dot(vertices(i,:),ydirection) + y*ydirection;
        end
    end
end