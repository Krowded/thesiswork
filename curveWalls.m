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
        for j = 1:length(curveStructs)
            %Assume frontVector in same plane as all wall frontnormals
            angle = acos(dot(wallStruct.frontNormal, curveStructs(j).normal));
            
            if angle > pi/2 %Nothing happens if over 90 degrees
                continue;
            end
            
            if angle > 0.0001 %Skip investigations around 0, it's problematic
                vec2D = flattenVertices([curveStructs(j).normal'; wallStruct.frontNormal], normalize(cross(curveStructs(j).normal', wallStruct.frontNormal)));
                angleSign = sign(vec2D(1,1)*vec2D(2,2) - vec2D(1,2)*vec2D(2,1));
                if isnan(angleSign)
                    angleSign = 1;
                end
                angle = angleSign*angle;
            end

            %Scale curve
            share = max(cos(angle),0);
            curveFunction = @(xq) curveStructs(j).curveFunction(xq)*share;
             
            %Get min and max so corners can scale properly
            minHeight = min(wallStruct.vertices(wallStruct.frontIndices,:)*wallStruct.upVector');
            maxHeight = max(wallStruct.vertices(wallStruct.frontIndices,:)*wallStruct.upVector');
            
            %Calculate biggest adjustment
            scale = (maxHeight - minHeight)/100;
            maxAdjustment = share * scale * curveStructs(j).span;
            
            %Curve the wall
            wallStruct = curveWall(wallStruct, wallStruct.frontIndices, curveFunction, wallStruct.frontNormal, minHeight, maxHeight);
            wallStruct.vertices(wallStruct.backIndices,:) = wallStruct.vertices(wallStruct.backIndices,:) - maxAdjustment*wallStruct.frontNormal;
%             wallStruct.vertices(wallStruct.frontIndices,:) = wallStruct.vertices(wallStruct.frontIndices,:) + maxAdjustment*wallStruct.frontNormal;
            wallStruct.adjustment = wallStruct.adjustment - maxAdjustment*wallStruct.frontNormal;

            %And adjacent corners
            wallStructToTheLeft = curveWall(wallStructToTheLeft, wallStructToTheLeft.frontCornerIndicesRight, curveFunction, wallStruct.frontNormal, minHeight, maxHeight);
            wallStructToTheLeft.vertices(wallStructToTheLeft.backCornerIndicesRight,:) = wallStructToTheLeft.vertices(wallStructToTheLeft.backCornerIndicesRight,:) - maxAdjustment*wallStruct.frontNormal;
%             wallStructToTheLeft.vertices(wallStructToTheLeft.frontCornerIndicesRight,:) = wallStructToTheLeft.vertices(wallStructToTheLeft.frontCornerIndicesRight,:) + maxAdjustment*wallStruct.frontNormal; 
            
            wallStructToTheRight = curveWall(wallStructToTheRight, wallStructToTheRight.frontCornerIndicesLeft, curveFunction, wallStruct.frontNormal, minHeight, maxHeight);
            wallStructToTheRight.vertices(wallStructToTheRight.backCornerIndicesLeft,:) = wallStructToTheRight.vertices(wallStructToTheRight.backCornerIndicesLeft,:) - maxAdjustment*wallStruct.frontNormal;
%             wallStructToTheRight.vertices(wallStructToTheRight.frontCornerIndicesLeft,:) = wallStructToTheRight.vertices(wallStructToTheRight.frontCornerIndicesLeft,:) + maxAdjustment*wallStruct.frontNormal;
        end
    end
end