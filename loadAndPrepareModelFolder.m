function returnStructure = loadAndPrepareModelFolder(folderpath)
    %Load
    returnStructure = loadModelFolder(folderpath);   
    
    %Fix missing information
    partNames = fieldnames(returnStructure);
    for i = 1:length(partNames)
        partName = char(string(partNames(i)));
        partModels = returnStructure.(partName).models;
        
        %Make slots for shape
        if ~isempty(returnStructure.(partName).shape) && isempty(returnStructure.(partName).shape.slots)
            returnStructure.(partName).shape.frontNormal = returnStructure.(partName).models(1).frontNormal;
            returnStructure.(partName).shape.upVector = returnStructure.(partName).models(1).upVector;
            returnStructure.(partName).shape.slots = slotsFromModel(returnStructure.(partName).shape);
        end
        
        for j = 1:length(partModels)
            model = partModels(j);
            
            %Same for everyone
            if isempty(model.faceNormals)
                returnStructure.(partName).models(j).faceNormals = calculateNormals(model.vertices, model.faces);
            end

            %Special cases
            if strcmp(partName, 'foundation')
                if isempty(model.frontIndices)
                    returnStructure.foundation.models(j) = calculateFrontAndBackIndices(returnStructure.(partName).models(j));
                end
            elseif strcmp(partName, 'roof')
                if isempty(model.slots)
                    if isfield(returnStructure, 'foundation')
                        foundationModels = returnStructure.foundation.models;
                        returnStructure.roof.models(j).slots = slotsFromRoofFoundationIntersection(model, foundationModels); 
                    else
                        returnStructure.roof.models(j).slots = slotsFromModel(model);
                    end
                end
            else %All other models
                if isempty(model.slots)
                    if isempty(returnStructure.(partName).shape)
                        returnStructure.(partName).models(j).slots = slotsFromModel(model);
                    else
                        returnStructure.(partName).models(j).slots = slotsFromModelVertices(returnStructure.(partName).shape.vertices, model.frontNormal, model.upVector);
                    end
                end
            end
        end
    end
end