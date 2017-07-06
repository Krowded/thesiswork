%Returns the curve vertices of a wallStruct, scaled so that the bottom one
%is at 0 and top one is at 100
function curveStruct = getWallCurve(wallStruct)
    sideVector = normalize(cross(wallStruct.upVector, wallStruct.frontVector));
    vertices = wallStruct.vertices;
    vertices = getTopPercentOfPoints(vertices, sideVector, 10);
    curveVertices = getCurveVertices(vertices, -sideVector, wallStruct.upVector);

    %Normalize so the highest point is at 100 and the lowest at 0
    [maxY, i] = max(curveVertices(:,2));
    minY = min(curveVertices(:,2));
    %minX = min(curveVertices(:,1));
    minX = curveVertices(i,1); %We want top vertex stationary later on
    normalizer = 100/(maxY-minY);
    curveVertices(:,2) = (curveVertices(:,2) - minY).*normalizer;
    curveVertices(:,1) = (curveVertices(:,1) - minX).*normalizer; %Same scale, different cutoff
    
    %Current depths
    minX = min(curveVertices(:,1));
    maxX = max(curveVertices(:,1));
    baseX = curveVertices(i,1);
    
    %Make return struct
    curveStruct.vertices = curveVertices;
    curveStruct.curveFunction = string('linear');
    curveStruct.curveLength = size(curveVertices,1);
    curveStruct.span = maxX - minX;
    curveStruct.backSpan = baseX - minX;
    curveStruct.normal = wallStruct.frontVector;
end