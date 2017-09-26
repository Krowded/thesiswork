function fullBuildingModel = buildCompleteStructure(foundationStructs, connectionStructs, foundationCurves, roofStruct, partsStructs)
    %Need to load either the model or the shape from disk for curve calculations
    %Presumably exists some decent way to precalculate this?     
    if ~isempty(roofStruct)
        roofModel = loadRoof(roofStruct);
        if isfield(roofStruct.shape, 'filepaths')
            roofShape = loadAndMergeModels(roofStruct.shape.filepaths);
        else
            roofShape = roofModel;
        end
        roofShape.slots = roofStruct.slots;
        
        if isfield(roofStruct, 'type')
            roofShape.type = roofStruct.type;
        else
            roofShape.type = string.empty;
        end
        
        %Attach roof        
        [foundationStructs, roofTransformationMatrix1, roofShape] = fitRoof(foundationStructs, roofShape); 
%         write_ply(roofShape.vertices, roofShape.faces,'roofShape.ply')
    end
    %Add connections
    [foundationStructs, connectionStructs] = addConnections(foundationStructs, connectionStructs, partsStructs);
    

    
    %Retriangulate    
    for i = 1:length(foundationStructs)
        holes = cell.empty();
        for j = 1:length(connectionStructs)
            if connectionStructs(j).connectedWall == i
                holes{end+1} = connectionStructs(j).holeStruct;
            end
        end
        
        if isempty(holes)
            holes = [];
        else
            holes = [holes{:}];
        end
        foundationStructs(i) = retriangulateWall(foundationStructs(i), holes);
    end
    
    %Curve wall
    foundationStructs = curveWalls(foundationStructs, foundationCurves);
    
    %Fit roof again.....
    if ~isempty(roofStruct)
        roofTransformationMatrix2 = reFitRoof(foundationStructs, roofShape);
        roofTransformationMatrix2(2,2) = 1;
        roofTransformationMatrix2(4,2) = 0;
        roofTransformationMatrix = roofTransformationMatrix2*roofTransformationMatrix1;
        roofModel.vertices = applyTransformation(roofModel.vertices, roofTransformationMatrix);
        roofStruct.slots = applyTransformation(roofStruct.slots, roofTransformationMatrix);
    end
    
    %Create missing parts of foundation (roof connection)    
    foundationStruct = fuseFoundation(foundationStructs);
    foundationStruct.slots = slotsFromModel(foundationStruct);
    
    
    %Insert parts into model
    collectedParts = newModelStruct();
    for i = 1:length(partsStructs)
        part = partsStructs{i};
        
        for j = 1:length(connectionStructs)
            if strcmp( connectionStructs(j).class, part.class ) %CHANGE TO USE UNIQUE ID INSTEAD OF NAME
                %Adjust transformation to curve
                if connectionStructs(j).connectedWall == 0 %Things connected to roof %CHANGE SO WE CAN HAVE COMPLETE DISCONNECTS TOO
                    slots = applyTransformation(partsStructs{i}.slots, connectionStructs(j).transformationMatrix);
                    upVector = connectionStructs(j).upVector;
                    if isempty(upVector)
                        warning('Connection lacking upVector. Using foundation upVector instead.');
                        upVector = foundationStruct.upVector;
                    end
                    
                    heights = slots*upVector';
                    [~, I] = sort(heights, 'ascend');
                    heights = heights(I(1:4));
                    slots = slots(I(1:4),:); %Keep only the four lowest slots (since ray tracing is pretty slow)

                    [~,distances] = raysFaceIntersect(roofModel.vertices, roofModel.faces, slots, upVector, 1);
                    if any(isnan(distances))
                        warning('NaN distance found');
                        continue;
                    end
                    
                    %Add and choose the lowest resulting height
                    heights = distances' + heights;
                    [~,I] = min(heights);
                    lowestTranslation = distances(I(1));
                    
                    %Sanity check
                    if isinf(lowestTranslation) || isnan(lowestTranslation); warning('Missed the roof?'); continue; end
                    adjustmentVector = lowestTranslation*upVector;
                elseif isempty(connectionStructs(j).connectedWall)
                    slotType = strsplit(part.slotType, '-');
                    switch slotType{1}
                        case 'surround'
                            switch slotType{2}
                                case 'foundation'
                                    connectionStructs(j).transformationMatrix = matchSlots(part.slots, foundationStruct.slots, 'non-uniform', foundationStruct.frontVector, foundationStruct.upVector);
                                case 'roof'
                                    connectionStructs(j).transformationMatrix = matchSlots(part.slots, roofStruct.slots, 'non-uniform', part.frontVector, part.upVector);
                                otherwise
                                   warning(['Haven t implemented arbitrary surround fitting. Skipping ' char(part.name)]);
                                   continue;
                            end
                            adjustmentVector = zeros(1,3);
                        case 'intersect'
                            warning(['Have not implemented automatic intersect add. Skipping ' char(part.name)]);
                        otherwise
                            warning(['Found no way to attach ' char(part.name) ' with slotType ' char(slotType) '. Skipping it.']);
                            continue;
                    end
                else
                    slotType = strsplit(part.slotType, '-');
                    switch slotType
                        case 'default'
                            adjustmentVector = foundationStructs(connectionStructs(j).connectedWall).adjustment;
                        case 'front'
                            
                        otherwise
                            adjustmentVector = foundationStructs(connectionStructs(j).connectedWall).adjustment;
                    end
                end
                connectionStructs(j).transformationMatrix = getTranslationMatrixFromVector(adjustmentVector) * connectionStructs(j).transformationMatrix;

                
                %Create instance %OBVIOUSLY DONT DO THIS IN FINAL PRODUCT, JUST SAVE TRANSFORMATION
                temp = loadAndMergeModels(part.filepaths);
                temp.vertices = applyTransformation(temp.vertices, connectionStructs(j).transformationMatrix);
                collectedParts = mergeModels([collectedParts, temp]);
            end
        end
    end
    
    %Merge everything into single model
    fullBuildingModel = newModelStruct(foundationStruct.vertices, foundationStruct.faces);
    fullBuildingModel = mergeModels([fullBuildingModel collectedParts]);
    
    %Insert roof into model
    if ~isempty(roofStruct)
        fullBuildingModel = mergeModels([fullBuildingModel roofModel]);
    end
end