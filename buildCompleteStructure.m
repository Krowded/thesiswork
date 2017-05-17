function fullBuildingModel = buildCompleteStructure(foundationStructs, connectionStructs, foundationCurves, roofStruct, partsStructs)
    %Need to load either the model or the shape from disk for curve calculations
    %Presumably exists some decent way to precalculate this?
    roofModel = loadAndMergeModels(roofStruct.filepaths);
    if isfield(roofStruct.shape, 'filepaths')
        roofShape = loadAndMergeModels(roofStruct.shape.filepaths);
    else
        roofShape = roofModel;
    end
    roofShape.slots = roofStruct.slots;

    %Attach roof 
    [foundationStructs, roofTransformationMatrix, changedAndNewIndices, roofCurveStructs, roofShape] = fitRoof(foundationStructs, roofShape);
    roofModel.vertices = applyTransformation(roofModel.vertices, roofTransformationMatrix);
    
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
            foundationStructs(i) = retriangulateWall(foundationStructs(i));
        else
            holes = [holes{:}];
            foundationStructs(i) = retriangulateWall(foundationStructs(i), holes);
        end        
    end
    
    
    %Remove bad faces
    for i = 1:length(foundationStructs)
%         foundationStructs(i) = removeFacesAboveCurve(foundationStructs(i), changedAndNewIndices{i}, roofCurveStructs(i).curveFunction);
        foundationStructs(i) = removeFacesAboveFaces(foundationStructs(i), changedAndNewIndices{i}, roofCurveStructs(i));
    end
    
    %Curve wall
    foundationStructs = curveWalls(foundationStructs, foundationCurves);

    %Create missing parts of foundation (roof connection)
    foundationStruct = fuseFoundation(foundationStructs, roofShape);
%     foundationStruct = mergeModels(foundationStructs)
    
    %Insert parts into model
    collectedParts = newModelStruct();
    for i = 1:length(partsStructs)
        partName = partsStructs{i}.name;
        
        for j = 1:length(connectionStructs)
            if strcmp( connectionStructs(j).name, partName ) %CHANGE TO USE UNIQUE ID INSTEAD OF NAME
                %Adjust transformation to curve
                if connectionStructs(j).connectedWall == 0 %Things connected to roof %CHANGE SO WE CAN HAVE COMPLETE DISCONNECTS TOO
                    slots = connectionStructs(j).slots;
                    upVector = connectionStructs(j).upVector;
                    heights = slots*upVector';
                    [~, I] = sort(heights, 'ascend');
                    heights = heights(I(1:4));
                    slots = slots(I(1:4),:); %Keep only the four lowest slots (since ray tracing is pretty slow)

                    distances = zeros(size(slots,1),1);
                    for k = 1:size(slots,1)
                        [~,distances(k)] = rayFaceIntersect(roofModel.vertices, roofModel.faces, slots(k,:), upVector, 1);
                        if isnan(distances(k))
                            warning('NaN distance found');
                        end
                    end

                    %Add and choose the lowest resulting height
                    heights = distances + heights;
                    [~,I] = min(heights);
                    lowestTranslation = distances(I);
                    
                    %Sanity check
                    if isinf(lowestTranslation) || isnan(lowestTranslation), error('Missed the roof?'), end
                    
                    adjustmentVector = lowestTranslation*upVector;
                else
                    adjustmentVector = foundationStructs(connectionStructs(j).connectedWall).adjustment;
                end

                connectionStructs(j).transformationMatrix = getTranslationMatrixFromVector(adjustmentVector) * connectionStructs(j).transformationMatrix;

                
                %Create instance %OBVIOUSLY DONT DO THIS IN FINAL PRODUCT, JUST SAVE TRANSFORMATION
                temp = loadAndMergeModels(partsStructs{i}.filepaths);
                temp.vertices = applyTransformation(temp.vertices, connectionStructs(j).transformationMatrix);
                collectedParts = mergeModels([collectedParts, temp]);
            end
        end
    end
    
    %Merge everything into single model
    foundationStruct = mergeModels([newModelStruct(foundationStruct.vertices, foundationStruct.faces) collectedParts]);

    %Insert roof into model
    fullBuildingModel = mergeModels([foundationStruct roofModel]);
end