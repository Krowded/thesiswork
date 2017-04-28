%Get models
house3D = loadAndPrepareModelFolder('testHouse');
magicHouse = loadAndPrepareModelFolder('testMagicHouse');
door = loadAndPrepareModelFolder('testDoor');
cottageDoor = loadAndPrepareModelFolder('cottageDoor');
silo = loadAndPrepareModelFolder('silo');

%%Add roof, adjust foundation
%3DHome roof
baseRoofStruct = house3D.roof.models;
foundationStructs = house3D.foundation.models;

%MagicHouse roof
newRoofStruct = mergeModels(magicHouse.roof.models);

%Match roof slots
newRoofStruct = matchModels(newRoofStruct, baseRoofStruct, 'non-uniform');

%Fit foundation to roof curve
lowestChangableHeight = min(baseRoofStruct.slots*baseRoofStruct.upVector');
changedAndNewIndices = cell(1,length(foundationStructs));
for i = 1:length(foundationStructs)
    %TODO: CHANGE CURVE CALCULATION TO LINE-TRIANGLE INTERSECTION WITH A SUBSET OF FACES FOR EXACT VALUES (PROBABLY WAY SLOWER)
    curveStruct = getCurveUnderRoof(newRoofStruct, foundationStructs(i));
    curveStructs(i) = curveStruct;
    [foundationStructs(i), changedAndNewIndices{i}] = fitWallToRoofCurve(foundationStructs(i), lowestChangableHeight, curveStruct.curveFunction, curveStruct.curveLength);
end

%%Add door
%3DHome door
door3DStruct = house3D.door.models;

%Magichouse door
doorMagicStruct = magicHouse.door.models;
doorconMagicStruct = magicHouse.door.shape;

%Decide on shape examples
wallTargetShape = door3DStruct;
newModelShape = doorconMagicStruct;

%Fit model shape to base shape
[~, M] = matchModels(newModelShape, wallTargetShape);

%Get contour and move to wall
newModelContour = extractSimplifiedContour3D(newModelShape.vertices, wallTargetShape.frontNormal);
newModelContour = applyTransformation(newModelContour, M);

%Constrain contour
T = constrainContour(foundationStructs(1).vertices, newModelContour, foundationStructs(1).upVector);
newModelContour = applyTransformation(newModelContour, T);
M = T*M;

%Carve door shape into front wall
[foundationStructs(1), holeStruct] = createHoleFromContour(foundationStructs(1), newModelContour);
holeStructs = [holeStruct];

%Retriangulate
foundationStructs(1) = retriangulateWall(foundationStructs(1), holeStructs);
for i = 2:length(foundationStructs)
    foundationStructs(i) = retriangulateWall(foundationStructs(i));
end

%Remove bad faces
for i = 1:length(foundationStructs)
    foundationStructs(i) = removeFacesAboveCurve(foundationStructs(i), changedAndNewIndices{i}, curveStructs(i).curveFunction);
end

%Create missing parts of foundation (roof connection)
foundationStruct = fuseFoundation(foundationStructs, newRoofStruct);

%Insert door into model
doorMagicStruct.vertices = applyTransformation(doorMagicStruct.vertices, M);
%foundationStruct = ([foundationStruct doorMagicStruct]);

%Merge in roof
fullHouseStruct = mergeModels([foundationStruct newRoofStruct]);

%Output
write_ply(fullHouseStruct.vertices, fullHouseStruct.faces,'test.ply','ascii');