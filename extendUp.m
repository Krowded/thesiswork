function wallStruct = extendUp(wallStruct, targetStruct)
    forward = wallStruct.frontVector;
    up = wallStruct.upVector;
    
    %Reduce faces to serach
    depths = wallStruct.vertices*forward';
    margin = 0.001;
    depthMin = min(depths) - margin;
    depthMax = max(depths) + margin;
    targetDepths = targetStruct.vertices*forward';
    edgeIndices = find(targetDepths > depthMin & targetDepths < depthMax);
    
    [targetStruct.vertices, targetStruct.faces] = removeUnreferencedVertices(targetStruct.vertices, targetStruct.faces);
    
    %If roof was too simple, just grab all vertices towards the edge
    if isempty(edgeIndices)
        edgeIndices = find(targetDepths > depthMin);

        %If still empty, just leave it
        if isempty(edgeIndices)
            warning('No edge vertices found, returning unextended')
            return;
        end
    end
    
    targetStruct.faces = removeFacesWithoutIndices(targetStruct.faces, edgeIndices);
    [targetStruct.vertices, targetStruct.faces] = removeUnreferencedVertices(targetStruct.vertices, targetStruct.faces);
    
    %Ray trace and get distance to intersection    
%     [~, distancesToIntersection] = raysFaceIntersect(targetStruct.vertices, targetStruct.faces, wallStruct.vertices([wallStruct.frontTopIndices; wallStruct.backTopIndices],:), up, 1);
    [~, distancesToIntersection] = raysFaceIntersect(targetStruct.vertices, targetStruct.faces, wallStruct.vertices(wallStruct.frontTopIndices,:), up, 1);    

    %Interpolate any NaNs if possible (THIS IS SO SHITTY MAN)
    nans = isnan(distancesToIntersection);
    numOfNaNs = nnz(nans);
    numOfDistances = length(distancesToIntersection);
    if numOfNaNs ~= 0 && numOfNaNs ~= numOfDistances
        indices = find(nans);
        for i = 1:numOfNaNs
            if indices(i) < 2 || indices(i) > (numOfDistances-1)
                continue;
            end

            lastNonNan = indices(i)-1;
            while any(lastNonNan == indices) && lastNonNan > 1
                lastNonNan = lastNonNan - 1;
            end
            nextNonNan = indices(i)+1;
            while any(nextNonNan == indices) && nextNonNan < numOfDistances
                nextNonNan = nextNonNan + 1;
            end

            distancesToIntersection(indices(i)) = (distancesToIntersection(lastNonNan) + distancesToIntersection(nextNonNan))/2;
        end
    end

    %Add new vertices above front
    distance = wallStruct.lineDistanceY;
    numFrontTopIndices = length(wallStruct.frontTopIndices);
    wallStructLength = size(wallStruct.vertices,1);
    for i = 1:numFrontTopIndices
        if isnan(distancesToIntersection(i)) %NaN means no intersection above it
            warning('No intersection found above')
            continue;
        end
        
        if distancesToIntersection(i) > 0
            verticesToAdd = ceil(distancesToIntersection(i)/distance);

            index = wallStruct.frontTopIndices(i);

            startIndex = wallStructLength+1;
            endIndex = wallStructLength+verticesToAdd;
            wallStruct.vertices(startIndex:endIndex,:) = zeros(verticesToAdd,3);        
            wallStruct.vertices(startIndex:(endIndex-1),:) = wallStruct.vertices(index,:) + (1:(verticesToAdd-1))'.*distance*up;
            wallStruct.vertices(endIndex,:) = wallStruct.vertices(index,:) + distancesToIntersection(i)*up;

            wallStruct.frontIndices(end+1:end+verticesToAdd) = (wallStructLength+1):(wallStructLength+verticesToAdd);
            wallStructLength = wallStructLength + verticesToAdd;
            wallStruct.frontTopIndices(i) = wallStructLength;
        else
            index = wallStruct.frontTopIndices(i);
            wallStruct.vertices(index,:) = wallStruct.vertices(index,:) + distancesToIntersection(i)*up;
        end
    end
    
%     %Just move the top indices from back up (no curving -> no need to add points)
%     numBackTopIndices = size(wallStruct.backTopIndices,1);
%     for i = 1:numBackTopIndices
%         if isnan(distancesToIntersection(numFrontTopIndices + i)) %NaN means no intersection above it
%             warning('No intersection found above')
%             continue;
%         end
%         
%         index = wallStruct.backTopIndices(i);
%         wallStruct.vertices(index,:) = wallStruct.vertices(index,:) + distancesToIntersection(numFrontTopIndices + i)*up;       
%     end
end