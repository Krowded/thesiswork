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
        slotType = part.slotType;
        slotType = strsplit(slotType,'-');
        switch slotType{1}
            case 'intersect'
                if isfield(set, slotType{2})
                    targetModel = mergeModels(set.(slotType{2}).models);
                    mergedModel = mergeModels(part.models); 
                    mergedModel.slotType = part.slotType;
%                     part.slots = slotsFromRoofFoundationIntersection(mergedModel, targetModel); 
                    part.slots = slotsFromModelIntersection(mergedModel, targetModel); 
                else
                    error(['Missing intersection target: ' char(slotType{2})]);
                end
            case 'surround'
                if isfield(set, slotType{2})
                    mergedModel.slotType = part.slotType;
                    part.slots = set.(slotType{2}).slots;
                else
                    error(['Missing surround target: ' char(slotType{2})]);
                end
            otherwise
                if ~isempty(part.shape.vertices)
                    part.contour = extractSimplifiedContour3D(part.shape.vertices, part.frontVector);
                    part.shape.frontVector = part.frontVector;
                    part.shape.upVector = part.upVector;
                    part.shape.slotType = part.slotType;
                    part.slots = slotsFromModel(part.shape);
                else %If no shape available, use full object
                    mergedModel = mergeModels(part.models);
                    part.contour = extractSimplifiedContour3D(mergedModel.vertices, part.frontVector);
                    mergedModel.frontVector = part.frontVector;
                    mergedModel.upVector = part.upVector;
                    mergedModel.slotType = part.slotType;
                    part.slots = slotsFromModel(mergedModel);
                end
        end        


        %Special case
        if strcmp(part.class, 'foundation')            
            part.curves = getFoundationCurves(part.models);
            foundation = part;
        end
        
        %Put back in set for easier reuse
        set.(partName) = part;

        %Remove vertices, faces etc that we don't need in the DB
        cleanPart = part;
        for k = 1:length(part.models)
            cleanPart.models(k).vertices = [];
            cleanPart.models(k).faces = [];
        end
%         cleanPart = rmfield(cleanPart, 'models');
        filepaths = cleanPart.shape.filepaths;
        cleanPart = rmfield(cleanPart, 'shape');
        cleanPart.shape = struct();
        cleanPart.shape.filepaths = string(filepaths);
        
        %Finally write to db
        writeStructToDB(cleanPart);
    end
end
