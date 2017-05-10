function fullBuildingModel = buildCompleteStructure(foundationStructs, connectionStructs, foundationCurves, roofStruct, partsStructs)
    %Need to load either the model or the shape from disk for curve calculations
    %Presumably exists some decent way to precalculate this?
    if isfield(roofStruct.shape, 'filepaths')
        roofShape = loadAndMergeModels(roofStruct.shape.filepaths);
    else
        roofShape = loadAndMergeModels(roofStruct.filepaths);
    end
    roofShape.slots = roofStruct.slots;

    %Attach roof 
    [foundationStructs, roofTransformationMatrix, changedAndNewIndices, roofCurveStructs, roofShape] = fitRoof(foundationStructs, roofShape);

    %Add connections
    [foundationStructs, holeStructs, connectionStructs] = addConnections(foundationStructs, connectionStructs, partsStructs);
    
    %Retriangulate    
    for i = 1:length(foundationStructs)
        holes = cell.empty();
        for j = 1:length(holeStructs)
            if holeStructs(j).connectedWall == i
                holes{end+1} = holeStructs(j);
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
        foundationStructs(i) = removeFacesAboveCurve(foundationStructs(i), changedAndNewIndices{i}, roofCurveStructs(i).curveFunction);
    end
    
    %Curve wall
    foundationStructs = curveWalls(foundationStructs, foundationCurves);

    %Create missing parts of foundation (roof connection)
    foundationStruct = fuseFoundation(foundationStructs, roofShape);
%     foundationStruct = mergeModels(foundationStructs)
    
    %Insert parts into model
    collectedParts = newModelStruct();
    for i = 1:length(partsStructs)
        partModel = loadAndMergeModels(partsStructs{i}.filepaths);
        partName = partsStructs{i}.name;
        
        for j = 1:length(connectionStructs)
            if strcmp( connectionStructs(j).name, partName ) %CHANGE TO USE UNIQUE ID INSTEAD OF NAME
                %Adjust transformation to curve
                adjustmentVector = foundationStructs(connectionStructs(j).connectedWall).adjustment;
                connectionStructs(j).transformationMatrix = getTranslationMatrixFromVector(adjustmentVector) * connectionStructs(j).transformationMatrix;

                %Create instance %OBVIOUSLY DONT DO THIS IN FINAL PRODUCT, JUST SAVE TRANSFORMATION
                temp = partModel;
                temp.vertices = applyTransformation(partModel.vertices, connectionStructs(j).transformationMatrix);
                collectedParts = mergeModels([collectedParts, temp]);
            end
        end
    end
    foundationStruct = mergeModels([foundationStruct collectedParts]);

    %Inser roof into model
    roof = loadAndMergeModels(roofStruct.filepaths);
    roof.vertices = applyTransformation(roof.vertices, roofTransformationMatrix);
    fullBuildingModel = mergeModels([foundationStruct roof]);
end