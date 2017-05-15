function [foundationStructs, roofM, changedAndNewIndices, roofCurveStructs, newRoofShape] = fitRoof(foundationStructs, newRoofShape)
    %Match roof slots
    roofM = matchSlots(newRoofShape.slots, foundationStructs(1).slots, 'uniform', foundationStructs(1).frontVector, foundationStructs(1).upVector);
    newRoofShape.slots = applyTransformation(newRoofShape.slots, roofM);
    newRoofShape.vertices = applyTransformation(newRoofShape.vertices, roofM);
    
    %Fit foundation to roof curve
%     lowestChangableHeight = min(foundationStructs(1).slots*foundationStructs(1).upVector');
%     changedAndNewIndices = cell(1,length(foundationStructs));
%     for i = 1:length(foundationStructs)
%         %TODO: CHANGE CURVE CALCULATION TO LINE-TRIANGLE INTERSECTION WITH A SUBSET OF FACES FOR EXACT VALUES (PROBABLY SLOWER THOUGH)
%         curveStruct = getCurveUnderRoof(newRoofShape, foundationStructs(i));
%         roofCurveStructs(i) = curveStruct;
%         [foundationStructs(i), changedAndNewIndices{i}] = fitWallToRoofCurve(foundationStructs(i), lowestChangableHeight, curveStruct.curveFunction, curveStruct.curveLength);
%     end

    roofCurveStructs = newModelStruct();
    changedAndNewIndices = cell(length(foundationStructs),1);
    for i = 1:length(foundationStructs)
        roofCurveStructs(i) = getRelevantFacesLocal(newRoofShape, foundationStructs(i));
       [foundationStructs(i), changedAndNewIndices{i}] = matchLocal(foundationStructs(i), roofCurveStructs(i));
    end
    

    %Returns a structure with all faces and vertices needed for projection from below
    function [returnStruct] = getRelevantFacesLocal(curveModel, positionModel)
        zdirection = positionModel.frontVector;
        indices = [positionModel.frontTopIndices; positionModel.backTopIndices];
        
        %Keep only points around the top of positionModel
        highestPoints = positionModel.vertices(indices ,:);
        positionModelDepths = highestPoints*zdirection';
        minDepth = min(positionModelDepths);
        maxDepth = max(positionModelDepths);

        curveModelDepths = curveModel.vertices*zdirection';
        margin = abs((max(curveModelDepths) - min(curveModelDepths))/50);
        vertexIndicesAroundPosition = curveModelDepths > (minDepth-margin) & curveModelDepths < (maxDepth+margin);
        vertexIndicesAroundPosition = find(vertexIndicesAroundPosition);

        %If roof was too simple, just grab all vertices towards the edge
        if isempty(vertexIndicesAroundPosition)
            vertexIndicesAroundPosition = find(curveModelDepths > minDepth);

            %If still empty, just grav every vertex
            if isempty(vertexIndicesAroundPosition)
                warning('No curve vertices found, returning NaN function')
                vertexIndicesAroundPosition = 1:size(curveModel.vertices,1);
            end
        end
        
        %Grab every faces touched by those vertices
        faceIndicesOfInterest = any(ismember(curveModel.faces, vertexIndicesAroundPosition),2);
        facesOfInterest = curveModel.faces(faceIndicesOfInterest,:);
        
        %Cull faces in other direction
        faceNormals = calculateNormals(curveModel.vertices, facesOfInterest);
        sameDirectionIndices = getSameDirectionFaceIndices(faceNormals, -positionModel.upVector, 0);
        facesOfInterest = facesOfInterest(sameDirectionIndices,:);
        
        %Find vertices connected by face
        vertexIndicesOfInterest = unique(facesOfInterest(:));
        vertices = curveModel.vertices(vertexIndicesOfInterest,:);
        
        %Adjust indices
        vertexIndicesOfInterest = sort(vertexIndicesOfInterest, 'ascend');
        correctedFaces = facesOfInterest;
        for j = 1:length(vertexIndicesOfInterest)
            correctedFaces(facesOfInterest(:) == vertexIndicesOfInterest(j)) = j;
        end
        
        %Create return struct
        returnStruct = newModelStruct();
        returnStruct.vertices = vertices;
        returnStruct.faces = correctedFaces;
    end

    %Projects each point to the face above it and adjusts its height to match
    function [wallStruct, changedAndNewIndices] = matchLocal(wallStruct, targetStruct)
        up = wallStruct.upVector;
        changedAndNewIndices = [wallStruct.frontTopIndices; wallStruct.backTopIndices];
        
        for j = 1:length(changedAndNewIndices)
            index = changedAndNewIndices(j);
            [~, distanceToIntersection] = rayFaceIntersect(targetStruct.vertices, targetStruct.faces, wallStruct.vertices(index,:), up, 1);
            if ~isnan(distanceToIntersection)
                wallStruct.vertices(index,:) = wallStruct.vertices(index,:) + distanceToIntersection*wallStruct.upVector;
            else
                warning('Distance was found to be NaN')
            end
        end
    end
end