magicHouse = loadAndPrepareModelFolder('testMagicHouse');
curves = getFoundationCurves(magicFoundationStructs);

%Make a new foundation
foundationStructs = buildAnySidedFoundation(8, 40000, 10000, 10000);

%Add roof
roof = newModelStruct();
temp = foundationStructs(1).vertices;
maxY = max(temp*foundationStructs(1).upVector');
model = mergeModels(foundationStructs);
roof.slots = slotsFromModelVertices(model.vertices, model.frontNormal, model.upVector) + maxY*foundationStructs(1).upVector;
roof.frontNormal = foundationStructs(1).frontNormal;
roof.upVector = foundationStructs(1).upVector;

%Match roof slots
newRoofStruct = mergeModels(magicHouse.roof.models);
newRoofStruct = matchModels(newRoofStruct, roof, 'non-uniform');

%Fit foundation to roof curve
lowestChangableHeight = min(roof.slots*foundationStructs(1).upVector');
changedAndNewIndices = cell(1,length(foundationStructs));
for i = 1:length(foundationStructs)
    %TODO: CHANGE CURVE CALCULATION TO LINE-TRIANGLE INTERSECTION WITH A SUBSET OF FACES FOR EXACT VALUES (PROBABLY SLOWER THOUGH)
    curveStruct = getCurveUnderRoof(newRoofStruct, foundationStructs(i));
    curveStructs(i) = curveStruct;
    [foundationStructs(i), changedAndNewIndices{i}] = fitWallToRoofCurve(foundationStructs(i), lowestChangableHeight, curveStruct.curveFunction, curveStruct.curveLength);
end



%Create a door
x = [1, 0, 0];
y = [0, 1, 0];
z = [0, 0, 1];
temp = foundationStructs(1).vertices;
maxX = max(temp*x');
minX = min(temp*x');
diff = abs(maxX - minX);
maxX = 5*diff/20 + minX;
minX = 4*diff/20 + minX;
maxY = max(temp*y');
minY = min(temp*y');
diff = abs(maxY - minY);
maxY = diff/5 + minY;
maxZ = max(temp*z');
minZ = min(temp*z');
door = [minX maxY maxZ;
        maxX maxY maxZ;
        maxX minY maxZ;
        minX minY maxZ;
        minX maxY minZ;
        maxX maxY minZ;
        maxX minY minZ;
        minX minY minZ];
door = newModelStruct(door);
door.upVector = [0, 1, 0];
door.frontNormal = foundationStructs(1).frontNormal;
door.slots = slotsFromModel(door);

door2 = loadAndPrepareModelFolder('testDoor');
door2 = door2.door;
shape = door2.shape;
door2 = door2.models;
[~, M] = matchModels(shape, door, 'uniform');

%Get contour and move to wall
newModelContour = extractSimplifiedContour3D(shape.vertices, door2.frontNormal);
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

%Curve wall
foundationStructs = curveWalls(foundationStructs, curves);

%Insert door into model
foundationStruct = mergeModels(foundationStructs);
door2.vertices = applyTransformation(door2.vertices, M);
foundationStruct = mergeModels([foundationStruct door2]);
foundationStruct = mergeModels([foundationStruct newRoofStruct]);

write_ply(foundationStruct.vertices, foundationStruct.faces, 'test.ply');