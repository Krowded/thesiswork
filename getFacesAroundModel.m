    %Returns a structure with all faces and vertices needed for projection from below
function [returnStruct] = getFacesAroundModel(curveModel, positionModel)
    zdirection = positionModel.frontVector;
    indices = [positionModel.gridIndicesFront(1,:) positionModel.gridIndicesBack(1,:)];
    
    %Keep only points around the top of positionModel
    highestPoints = positionModel.vertices(indices ,:);
    positionModelDepths = highestPoints*zdirection';
    minDepth = min(positionModelDepths);
    maxDepth = max(positionModelDepths);

    curveModelDepths = curveModel.vertices*zdirection';
    margin = abs((max(curveModelDepths) - min(curveModelDepths))/50);
    vertexIndicesAroundPosition = curveModelDepths > (minDepth-margin) & curveModelDepths < (maxDepth+margin);
    vertexIndicesAroundPosition = find(vertexIndicesAroundPosition);

%     If roof was too simple, just grab all vertices towards the edge
    if isempty(vertexIndicesAroundPosition)
        vertexIndicesAroundPosition = find(curveModelDepths > minDepth);

%         If still empty, just grav every vertex
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