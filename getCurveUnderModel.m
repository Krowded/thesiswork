%Returns a curve function representing the curve under the model at the
%position of positionModel
function [curve, curveLength] = getCurveUnderModel(curveModel, positionModel)
    ydirection = positionModel.upVector;
    zdirection = positionModel.frontNormal;
    xdirection = normalize(cross(ydirection, zdirection));
    
    %Keep only points around the top of positionModel
    highestPoints = getTopPercentOfPoints(positionModel.vertices, ydirection, 10);
    positionModelDepths = highestPoints*zdirection';
    minDepth = min(positionModelDepths);
    maxDepth = max(positionModelDepths);
    
    curveModelDepths = curveModel.vertices*zdirection';
    margin = abs((max(curveModelDepths) - min(curveModelDepths))/50);
    verticesAroundPosition = curveModelDepths > (minDepth-margin) & curveModelDepths < (maxDepth+margin);
    vertices = curveModel.vertices(verticesAroundPosition, :);
    
    %If roof was too simple, just grab all vertices towards the edge
    if isempty(vertices)
        vertices = curveModel.vertices(curveModelDepths > minDepth,:);
        
        %If still empty, just grab all vertices
        if isempty(vertices)
            error('No curve vertices found')
        end
    end
    
    %Change basis
    B = [xdirection', ydirection', zdirection'];
    B = inv(B);
    vertices = matrixMultByRow(vertices, B);
    
    %Sort by 'x'
    flatVertices = sortrows(vertices(:,1:2), 1);
    
    %Remove points with the same x value
    i = 1;
    while i < size(flatVertices,1)
        thisX = flatVertices(i,1);
        nextX = flatVertices(i+1,1);

        %If very close to each other, remove the higher one
        if abs(thisX - nextX) < 0.001
            thisY = flatVertices(i,2);
            nextY = flatVertices(i+1,2);
            flatVertices(i,2) = min( [thisY, nextY] );
            flatVertices(i+1,:) = [];
            continue;
        end
        i = i + 1;
    end
    
    %Get x and y
    x = flatVertices(:,1);
    y = flatVertices(:,2);
       
    %Length of curve is equal to number of x points
    curveLength = size(x,1);
    
    if curveLength < 2 %Return NaN if too many points got removed
        curve = @(xq) NaN;
    else
        curve = @(xq) interp1(x,y,xq,'linear');
    end
end