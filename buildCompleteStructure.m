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
    connectedWall = 1; %TEMP FIX
    foundationStructs(connectedWall) = retriangulateWall(foundationStructs(connectedWall), holeStructs);
    for i = 1:length(foundationStructs)
        if i == connectedWall
            continue;
        end

        foundationStructs(i) = retriangulateWall(foundationStructs(i));
    end

    %Remove bad faces
    for i = 1:length(foundationStructs)
        foundationStructs(i) = removeFacesAboveCurve(foundationStructs(i), changedAndNewIndices{i}, roofCurveStructs(i).curveFunction);
    end

    %Curve wall
%    foundationStructs = curveWalls(foundationStructs, foundationCurves);

    %Create missing parts of foundation (roof connection)
    foundationStruct = fuseFoundation(foundationStructs, roofShape);

    %Insert parts into model
    %CAREFUL. ONE PART COULD BE USED SEVERAL TIMES AND/OR DIFFERENT ORDER > FIX!
    collectedParts = newModelStruct();
    for i = 1:length(connectionStructs)        
        %Adjust transformation to curve
        adjustmentVector = foundationStructs(connectionStructs(i).connectedWall).adjustment;
        connectionStructs(i).transformationMatrix = getTranslationMatrixFromVector(adjustmentVector) * connectionStructs.transformationMatrix;
        
        temp = loadAndMergeModels(partsStructs{i}.filepaths);
        temp.vertices = applyTransformation(temp.vertices, connectionStructs(i).transformationMatrix);
        
        collectedParts = mergeModels([collectedParts, temp]);
    end
    foundationStruct = mergeModels([foundationStruct collectedParts]);

    %Inser roof into model
    roof = loadAndMergeModels(roofStruct.filepaths);
    roof.vertices = applyTransformation(roof.vertices, roofTransformationMatrix);
    fullBuildingModel = mergeModels([foundationStruct roof]);
end