%Curves each wall and it's corner according to their angle to each curveStruct normal
%Assumes walls are in winding order from right to left
%Assumes frontNormals and curve normals are all in the same plane
function wallStructs = curveWalls(wallStructs, curveStructs)
    %Walls are in winding order, so left of is always one index ahead and
    %right is always one index behind
    [wallStructs(1), wallStructs(2), wallStructs(end)] = localCurveWallAndCorners(wallStructs(1), wallStructs(2), wallStructs(end));
    for i = 2:length(wallStructs)-1
        [wallStructs(i), wallStructs(i+1), wallStructs(i-1)] = localCurveWallAndCorners(wallStructs(i), wallStructs(i+1), wallStructs(i-1));
    end
    [wallStructs(end), wallStructs(1), wallStructs(end-1)] = localCurveWallAndCorners(wallStructs(end), wallStructs(1), wallStructs(end-1));    
    
    function [wallStruct, wallStructToTheLeft, wallStructToTheRight] = localCurveWallAndCorners(wallStruct, wallStructToTheLeft, wallStructToTheRight)       
        %Get min and max so corners can scale properly
        frontVector = wallStruct.frontVector;
        upVector = wallStruct.upVector;
        heights = wallStruct.vertices(wallStruct.frontIndices,:)*upVector';
        minHeight = min(heights);
        maxHeight = max(heights);
        curveFunction = collectCurves(curveStructs, frontVector);

        %Curve the wall
        [wallStruct, maxAdjustment] = curveWall(wallStruct, wallStruct.frontIndices, curveFunction, frontVector, minHeight, maxHeight);
%         maxAdjustment = -maxAdjustment;
        wallStruct.vertices(wallStruct.backIndices,:) = wallStruct.vertices(wallStruct.backIndices,:) + maxAdjustment*frontVector;
        wallStruct.adjustment = wallStruct.adjustment + maxAdjustment*frontVector; %Addition, just in case adjustment is done somewhere else too
        
        %And adjacent corners
        wallStructToTheLeft = compressWall(wallStructToTheLeft, maxAdjustment, -frontVector);
        wallStructToTheRight = compressWall(wallStructToTheRight, maxAdjustment, -frontVector);
    end
end