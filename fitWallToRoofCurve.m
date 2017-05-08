%Takes all vertices above the lowest slot and changes their heights to
%match the curve 
function [wallStruct, changedAndNewIndices] = fitWallToRoofCurve(wallStruct, lowestChangableHeight, curve, minNumberOfPoints)
    if nargin < 4
        minNumberOfPoints = -Inf;
    end
    
    ydirection = wallStruct.upVector;
    zdirection = wallStruct.frontNormal;
    xdirection = normalize(cross(ydirection, zdirection));
    
    margin = 0.001;

    changedAndNewIndices = [];

    %%Front
        heights = wallStruct.vertices(wallStruct.frontIndices,:)*ydirection';
        indicesToChange = wallStruct.frontIndices(heights > (lowestChangableHeight-margin));
        newVertices = fitModelToCurve(wallStruct.vertices(indicesToChange,:), curve, xdirection, ydirection, minNumberOfPoints);

        %Replace old vertices
        lengthOfOldIndices = length(indicesToChange);
        wallStruct.vertices(indicesToChange,:) = newVertices(1:lengthOfOldIndices,:);
        changedAndNewIndices = [changedAndNewIndices; indicesToChange];

        %Append any new vertices
        if lengthOfOldIndices < minNumberOfPoints
            oldSize = size(wallStruct.vertices,1);
            wallStruct.vertices = [wallStruct.vertices; newVertices((lengthOfOldIndices+1):end,:)];
            newSize = size(wallStruct.vertices,1);
            newIndices = ((oldSize+1):newSize)';
            wallStruct.frontIndices = [wallStruct.frontIndices; newIndices];
            changedAndNewIndices = [changedAndNewIndices; newIndices];
        end
% 
%     %Back
%         heights = wallStruct.vertices(wallStruct.backIndices,:)*ydirection';
%         indicesToChange = wallStruct.backIndices(heights > (lowestChangableHeight-margin));
%         newVertices = fitModelToCurve(wallStruct.vertices(indicesToChange,:), curve, xdirection, ydirection, minNumberOfPoints);
% 
%         %Replace old vertices
%         lengthOfOldIndices = length(indicesToChange);
%         wallStruct.vertices(indicesToChange,:) = newVertices(1:lengthOfOldIndices,:);
%         changedAndNewIndices = [changedAndNewIndices; indicesToChange];
% 
%         %Append any new vertices
%         if lengthOfOldIndices < minNumberOfPoints
%             oldSize = size(wallStruct.vertices,1);
%             wallStruct.vertices = [wallStruct.vertices; newVertices((lengthOfOldIndices+1):end,:)];
%             newSize = size(wallStruct.vertices,1);
%             newIndices = ((oldSize+1):newSize)';
%             wallStruct.backIndices = [wallStruct.backIndices; newIndices];
%             changedAndNewIndices = [changedAndNewIndices; newIndices];
%         end
end