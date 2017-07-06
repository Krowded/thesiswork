%Curves each wall and it's corner according to their angle to each curveStruct normal
%Assumes walls are in winding order from right to left
%Assumes frontNormals and curve normals are all in the same plane
function model = curveModel(model, forward, curveDirection, curveStructs)

    %Get min and max so corners can scale properly
    frontVector = forward;
    upVector = curveDirection;
    heights = model.vertices*upVector';
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
%         maxAdjustment = 0;
    for j = 1:length(curveStructs)
        curveFunction = @(xq) curveFunction(xq) + curveStructs(j).curveFunction(xq)*shares(j);
    end

    %Curve the wall
    model.vertices = curveVertices(model.vertices, curveFunction, curveDirection, forward, minHeight, maxHeight);
end