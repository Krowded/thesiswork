%Returns a curve function representing the curve under the model at the
%position of positionModel
function [curveVertices] = getCurveUnderModelVertices(curveModel, positionModel)
    ydirection = positionModel.upVector;
    zdirection = positionModel.frontNormal;
    
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
            vertices = curveModel.vertices;
        end
    end
    
    curveVertices = getCurveVertices(vertices, zdirection, ydirection);
end