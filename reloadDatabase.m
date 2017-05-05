setupDBScript
collection.drop

infoFiles = rdir('Archive', 'info.txt');
for i = 1:length(infoFiles)
    modelFolder = extractBefore(infoFiles(i), 'info.txt');
    set = loadModelFolder(modelFolder);
    parts = fieldnames(set);
    for j = 1:length(parts)
        partName = parts{j};
        part = set.(partName);
        
        %Calculate contour and slots
        if strcmp(partName, 'roof')
            if isfield(set, 'foundation')
                foundationModels = set.foundation.models;
                mergedModel = mergeModels(part.models);
                part.slots = slotsFromRoofFoundationIntersection(mergedModel, foundationModels); 
            else
                part.slots = slotsFromModel(mergeModels(part.models));
            end
        else
            if ~isempty(part.shape)
                part.contour = extractSimplifiedContour3D(part.shape.vertices, part.frontNormal);
                part.shape.frontNormal = part.frontNormal;
                part.shape.upVector = part.upVector;
                part.slots = slotsFromModel(part.shape);
            else %If no shape available, use full object
                mergedModel = mergeModels(part.models);
                part.contour = extractSimplifiedContour3D(mergedModel.vertices, part.frontNormal);
                mergedModel.frontNormal = part.frontNormal;
                mergedModel.upVector = part.upVector;
                part.slots = slotsFromModel(mergedModel);
            end
        end
        
        %Special case
        if strcmp(parts{j}, 'foundation')
            part.curves = getFoundationCurves(part.models);
            foundation = part;
        end
        
        %If walls can be known, maybe precalculate roof curves too?
        %TODO
        
        %Remove vertices, faces etc that we don't need in the DB
        cleanPart = part;
        cleanPart = rmfield(cleanPart, 'models');
        cleanPart = rmfield(cleanPart, 'shape');    
        
        %Finally write to db
        writeStructToDB(cleanPart);
    end
end
