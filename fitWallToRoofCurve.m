%Takes all vertices above the lowest slot and changes their heights to
%match the curve 
function [wallStruct, changedAndNewIndices] = fitWallToRoofCurve(wallStruct, lowestChangableHeight, curve, minNumberOfPoints)
    if nargin < 4
        minNumberOfPoints = -Inf;
    end
    
    ydirection = wallStruct.upVector;
    zdirection = wallStruct.frontVector;
    xdirection = normalize(cross(ydirection, zdirection));
    
    margin = 0.001;
    lowestChangableHeight = lowestChangableHeight - margin;

    changedAndNewIndices = [];
    
    %Fit front
    [wallStruct, changedIndices, newIndices] = fitToCurveLocal(wallStruct, wallStruct.frontTopIndices);
    wallStruct.frontTopIndices = [wallStruct.frontTopIndices; newIndices];
    wallStruct.frontIndices = [wallStruct.frontIndices; newIndices];
    changedAndNewIndices = [changedAndNewIndices; changedIndices; newIndices];
    
    %Fit back
    [wallStruct, changedIndices, newIndices] = fitToCurveLocal(wallStruct, wallStruct.backTopIndices);
    wallStruct.backTopIndices = [wallStruct.backTopIndices; newIndices];
    wallStruct.backIndices = [wallStruct.backIndices; newIndices];
    changedAndNewIndices = [changedAndNewIndices; changedIndices; newIndices];

        
    function [wallStruct, changedIndices, newIndices] = fitToCurveLocal(wallStruct, indicesToChange)
%         heights = wallStruct.vertices(indices,:)*ydirection';
%         indicesToChange = indices(heights > lowestChangableHeight);
        newVertices = fitModelToCurve(wallStruct.vertices(indicesToChange,:), curve, xdirection, ydirection, minNumberOfPoints);

        %Replace old vertices
        lengthOfOldIndices = length(indicesToChange);
        wallStruct.vertices(indicesToChange,:) = newVertices(1:lengthOfOldIndices,:);
        changedIndices = indicesToChange;
        
        %Append any new vertices
        newIndices = [];
        if lengthOfOldIndices < minNumberOfPoints
            oldSize = size(wallStruct.vertices,1);
            wallStruct.vertices = [wallStruct.vertices; newVertices((lengthOfOldIndices+1):end,:)];
            newSize = size(wallStruct.vertices,1);
            newIndices = ((oldSize+1):newSize)';
        end
    end
end