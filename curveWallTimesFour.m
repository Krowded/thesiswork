function [wallStruct, wallStructToTheRight, wallStructToTheLeft] = curveWallTimesFour(wallStruct, wallStructToTheRight, wallStructToTheLeft, curveStructs, frontVector)
    %Assume frontVector in same plane as all wall frontnormals
    angle = acos(dot(wallStruct.frontNormal, frontVector));
    if angle > 0.001 && angle < pi-0.001
        vec2D = flattenVertices([frontVector; wallStruct.frontNormal], normalize(cross(frontVector, wallStruct.frontNormal)));
        angleSign = sign(vec2D(1,1)*vec2D(2,2) - vec2D(1,2)*vec2D(2,1));
        if isnan(angleSign)
            angleSign = 1;
        end
        angle = angleSign*angle;
    end

    frontShare = max(cos(angle),0);
    leftShare = max(sin(angle),0);
    backShare = max(-cos(angle),0);
    rightShare = max(-sin(angle),0);
    amount = [frontShare leftShare backShare rightShare];
    
   
    for i = 1:4
        curveFunction = @(xq) curveStructs(i).curveFunction(xq)*amount(i);
        wallStruct = curveWall(wallStruct, curveFunction);
        
        %Adjacent corners
        wallStructToTheLeft = curveRightCorner(wallStructToTheLeft, curveFunction, wallStruct.frontNormal);
        wallStructToTheRight = curveLeftCorner(wallStructToTheRight, curveFunction, wallStruct.frontNormal);
    end
end