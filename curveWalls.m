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
        scale = (maxHeight - minHeight)/100;
        
        %Get size of contribution from each curve
        shares = zeros(length(curveStructs),1);
        for j = 1:length(curveStructs)            
            %Assume frontVector in same plane as all wall frontnormals
            angle = acos(dot(frontVector, curveStructs(j).normal));
            
            if angle > pi/2 %Nothing happens if over 90 degrees
                continue;
            end
            
            if angle > 0.0001 %Skip investigations around 0, it's problematic
                vec2D = flattenVertices([curveStructs(j).normal'; frontVector], normalize(cross(curveStructs(j).normal', frontVector)));
                angleSign = sign(vec2D(1,1)*vec2D(2,2) - vec2D(1,2)*vec2D(2,1));
                if isnan(angleSign)
                    angleSign = 1;
                end
                angle = angleSign*angle;
            end

            %Scale curve
            shares(j) = max(cos(angle),0);
        end
        %Normalize shares so it adds up to 1
        shares = shares./sum(shares);
        
        %Gather contribution from each curve function
        curveFunction = @(xq) 0;
        maxAdjustment = 0;
        for j = 1:length(curveStructs)
            curveFunction = @(xq) curveFunction(xq) + curveStructs(j).curveFunction(xq)*shares(j);
             
            %Calculate biggest adjustment
            maxAdjustment = max(maxAdjustment, (shares(j) * scale * curveStructs(j).span));
        end
            
        %Curve the wall
        wallStruct = curveIndicesLocal(wallStruct, wallStruct.frontIndices, wallStruct.backIndices, maxAdjustment, curveFunction, frontVector, minHeight, maxHeight);
        wallStruct.adjustment = wallStruct.adjustment - maxAdjustment*frontVector; %Addition, just in case adjustment is done somewhere else too

        %And adjacent corners
        wallStructToTheLeft = curveIndicesLocal(wallStructToTheLeft, wallStructToTheLeft.frontCornerIndicesRight, wallStruct.backCornerIndicesRight, maxAdjustment, curveFunction, frontVector, minHeight, maxHeight);
        wallStructToTheRight = curveIndicesLocal(wallStructToTheRight, wallStructToTheRight.frontCornerIndicesLeft, wallStruct.backCornerIndicesLeft, maxAdjustment, curveFunction, frontVector, minHeight, maxHeight);
    end

    function [wallStruct] = curveIndicesLocal(wallStruct, frontIndices, backIndices, adjustment, curveFunction, curveDirection, minHeight, maxHeight)
        wallStruct = curveWall(wallStruct, frontIndices, curveFunction, curveDirection, minHeight, maxHeight);
        wallStruct.vertices(backIndices,:) = wallStruct.vertices(backIndices,:) - adjustment*curveDirection; 
    end
end