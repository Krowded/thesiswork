function curveVertices = getWallCurve(wallStruct)
    sideVector = normalize(cross(wallStruct.upVector, wallStruct.frontNormal));
    vertices = wallStruct.vertices;
    vertices = getTopPercentOfPoints(vertices, sideVector, 10);
    
    vertices = changeBasis(vertices, sideVector, wallStruct.upVector, wallStruct.frontNormal);

    flattenedVertices = vertices(:,1:2);
    flattenedVertices = flattenedVertices(boundary(flattenedVertices(:,1), flattenedVertices(:,2), 0.9), :);
    
    %Since flattened vertices are in order, we can just check if the vector
    %between two consecutive ones are positive in the y direction
    curveVertices = [];
    for i = 1:(size(flattenedVertices,1)-1)
        edge = flattenedVertices(i+1,:) - flattenedVertices(i,:);
        if edge(2) > 0
            curveVertices(end+1,:) = flattenedVertices(i,:);
        end
    end
    
    %Last one
    edge = flattenedVertices(1,:) - flattenedVertices(end,:);
    if edge(2) > 0 &&
        curveVertices(end+1) = flattenedVertices(1,:);
    end
    
    curveVertices = getExtremePoints(curveVertices, [0 1], [1 0]);
end