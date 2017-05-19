function [foundationStructs, roofM, changedAndNewIndices, roofCurveStructs, newRoofShape] = fitRoof(foundationStructs, newRoofShape)
    %Match roof slots
    roofM = matchSlots(newRoofShape.slots, foundationStructs(1).slots, 'uniform', foundationStructs(1).frontVector, foundationStructs(1).upVector);
    newRoofShape.slots = applyTransformation(newRoofShape.slots, roofM);
    newRoofShape.vertices = applyTransformation(newRoofShape.vertices, roofM);
    
    %Fit foundation to roof curve
%     lowestChangableHeight = min(foundationStructs(1).slots*foundationStructs(1).upVector');
%     changedAndNewIndices = cell(1,length(foundationStructs));
%     for i = 1:length(foundationStructs)
	
%         curveStruct = getCurveUnderRoof(newRoofShape, foundationStructs(i));
%         roofCurveStructs(i) = curveStruct;
%         [foundationStructs(i), changedAndNewIndices{i}] = fitWallToRoofCurve(foundationStructs(i), lowestChangableHeight, curveStruct.curveFunction, curveStruct.curveLength);
%     end

    %Calculate curves
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
        front = wallStruct.frontVector';
        side = wallStruct.sideVector';
        xvertices = targetStruct.vertices*side;
        zvertices = targetStruct.vertices*front;
        maxX = max(xvertices);
        minX = min(xvertices);
        maxZ = max(zvertices);
        minZ = min(zvertices);        
        
        changedAndNewIndices = [wallStruct.frontTopIndices; wallStruct.backTopIndices];

        tempTargetVertices = targetStruct.vertices;
        tempTargetFaces = targetStruct.faces;

        vertices = wallStruct.vertices(changedAndNewIndices,:);
        for j = 1:size(vertices,1)
            vertex = vertices(j,:);
            
            %Check if outside
            x = vertex*side;
            z = vertex*front;
            
            if ~(x > maxX || x < minX || z > maxZ || z < minZ)
                [~, distanceToIntersection] = rayFaceIntersect(tempTargetVertices, tempTargetFaces, vertex, up, 1);
                if ~isnan(distanceToIntersection)
                    vertices(j,:) = vertex + distanceToIntersection*up;
                else
                    %No intersection found
                end
            end
        end
        wallStruct.vertices(changedAndNewIndices,:) = vertices;
    end
end