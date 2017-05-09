%Create a new foundation
[foundationStructs, connectionStructs] = newFoundation();

%Find all the needed parts
style = string('magic');

partNames = string.empty;
for i = 1:length(connectionStructs)
    partNames(i) = string(connectionStructs.name);
end

magicRoof = findFirst([string('name'), string('style')], [string('roof'), style]);
magicFoundation = findFirst([string('name'), string('style')], [string('foundation'), style]);
matchingParts = findAll([string('name'), string('style')], [partNames, style]);
magicDoor = matchingParts{1};
newRoof = magicRoof;

%Turn curve vertices into curveFunctions
for i = 1:length(magicFoundation.curves)
    magicFoundation.curves(i).curveFunction = @(xq) interp1(magicFoundation.curves(i).vertices(:,2), magicFoundation.curves(i).vertices(:,1), xq, 'linear', 'extrap');
end
    
%Need to load either the model or the shape from disk for curve calculations
%Presumably exists some decent way to precalculate this?
if isfield(newRoof.shape, 'filepaths')
    newRoofShape = loadAndMergeModels(newRoof.shape.filepaths);
else
    newRoofShape = loadAndMergeModels(newRoof.filepaths);
end
newRoofShape.slots = newRoof.slots;

%Attach roof 
[foundationStructs, roofM, changedAndNewIndices, roofCurveStructs, newRoofShape] = fitRoof(foundationStructs, newRoofShape);

%Add connections
[foundationStructs, holeStructs, transformationMatrices] = addConnections(foundationStructs, connectionStructs, matchingParts);
doorM = transformationMatrices{1};

%Retriangulate
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
foundationStructs = curveWalls(foundationStructs, magicFoundation.curves);

%Adjust M to curve
doorM = getTranslationMatrixFromVector(foundationStructs(1).adjustment) * doorM;

%Create missing parts of foundation (roof connection)
foundationStruct = fuseFoundation(foundationStructs, newRoofShape);

%Insert parts
%CAREFUL. ONE PART COULD BE USED SEVERAL TIMES AND/OR DIFFERENT ORDER > FIX!
tempAll = newModelStruct();
for i = 1:length(matchingParts)
    temp = loadAndMergeModels(matchingParts{i}.filepaths);
    temp.vertices = applyTransformation(temp.vertices, transformationMatrices{i});
    temp = mergeModels([tempAll, temp]);
end
foundationStruct = mergeModels([foundationStruct door2]);

%Inser roof into model
roof2 = loadAndMergeModels(magicRoof.filepaths);
roof2.vertices = applyTransformation(roof2.vertices, roofM);
foundationStruct = mergeModels([foundationStruct roof2]);

write_ply(foundationStruct.vertices, foundationStruct.faces, 'test.ply');