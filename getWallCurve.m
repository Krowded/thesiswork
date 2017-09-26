%Returns the curve vertices of a wallStruct, scaled so that the bottom one
%is at 0 and top one is at 100
function curveStruct = getWallCurve(wallStruct)
    sideVector = normalize(cross(wallStruct.upVector, wallStruct.frontVector));
    vertices = wallStruct.vertices;
    vertices = getTopPercentOfPoints(vertices, sideVector, 10);
    curveVertices = getCurveVertices(vertices, -sideVector, wallStruct.upVector);
    if isempty(curveVertices)
        curveStruct = [];
        return;
    end
    
    %Current depths
    [~, i] = max(curveVertices(:,2));
    minX = min(curveVertices(:,1));
    maxX = max(curveVertices(:,1));
    baseX = curveVertices(i,1);
    
    %Make return struct
    curveStruct.vertices = curveVertices;
    curveStruct.curveFunction = string('linear');
    curveStruct.curveLength = size(curveVertices,1);
    curveStruct.normal = wallStruct.frontVector;
end