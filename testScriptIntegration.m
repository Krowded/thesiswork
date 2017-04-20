%Get models

%Set normal (TODO)
normal = [-1,0,0];
up = [0, 1, 0];
side = [0, 0, 1];

%%Add roof, adjust foundation

%3DHome roof
filepaths = [string('3dhome/roofLeft.ply');
             string('3dhome/roofRight.ply')];
roof3DStruct = loadAndMergeModels(filepaths);

%3DHome foundation
filepaths = string('3dhome/wallFront.ply');
wallFrontStruct = loadAndMergeModels(filepaths, [-1, 0, 0]);
filepaths = string('3dhome/wallLeft.ply');
wallLeftStruct = loadAndMergeModels(filepaths, [0, 0, -1]);
filepaths = string('3dhome/wallRight.ply');
wallRightStruct = loadAndMergeModels(filepaths, [0, 0, 1]);
filepaths = string('3dhome/wallBack.ply');
wallBackStruct = loadAndMergeModels(filepaths, [1, 0, 0]);

%MagicHouse roof
filepaths = [string('magichouse/roofLeft.ply')
             string('magichouse/roofRight.ply')];
roofMagicStruct = loadAndMergeModels(filepaths);

%MagicHouse foundation
filepaths = [string('magichouse/wallFront.ply')
             string('magichouse/wallLeft.ply')
             string('magichouse/wallRight.ply')
             string('magichouse/wallBack.ply')];
foundationMagicStruct = loadAndMergeModels(filepaths);

%Get slots from the intersection between roof and foundation
foundationVertices = [wallFrontStruct.vertices; wallLeftStruct.vertices; wallRightStruct.vertices; wallBackStruct.vertices];
roof3DStruct.slots = slotsFromRoofFoundationIntersection(roof3DStruct.vertices, foundationVertices, normal, up);
roofMagicStruct.slots = slotsFromRoofFoundationIntersection(roofMagicStruct.vertices, foundationMagicStruct.vertices, normal, up);

%Calculate non-uniform scaling
S = scaleMatrixFromSlots(roofMagicStruct.slots, roof3DStruct.slots, normal, up);
roofMagicStruct.slots = applyTransformation(roofMagicStruct.slots, S);

%Slot fitting
[regParams,Bfit,ErrorStats] = absor(roofMagicStruct.slots', roof3DStruct.slots', 'doScale', 0, 'doTrans', 1);

%Apply complete transformation
M = regParams.M;
M = M*S;
roofMagicStruct.vertices = applyTransformation(roofMagicStruct.vertices, M);

%Get roof curve
curveFunction = getCurveUnderModel(roofMagicStruct.vertices, side, up, normal);

%Get normals and front portion here since curvefitting messes up faces
wallFrontStruct = calculateFrontAndBackIndices(wallFrontStruct);
wallLeftStruct = calculateFrontAndBackIndices(wallLeftStruct);
wallRightStruct = calculateFrontAndBackIndices(wallRightStruct);
wallBackStruct = calculateFrontAndBackIndices(wallBackStruct);


%Fit foundation to curve
%NEED TO INTRODUCE MORE VERTICES IF TOO SIMPLE
lowestChangableHeight = min(roof3DStruct.slots*up');
wallFrontStruct.vertices = fitFoundationToCurve(wallFrontStruct.vertices, lowestChangableHeight, curveFunction, side, up);
wallLeftStruct.vertices = fitFoundationToCurve(wallLeftStruct.vertices, lowestChangableHeight, curveFunction, side, up);
wallRightStruct.vertices = fitFoundationToCurve(wallRightStruct.vertices, lowestChangableHeight, curveFunction, side, up);
wallBackStruct.vertices = fitFoundationToCurve(wallBackStruct.vertices, lowestChangableHeight, curveFunction, side, up);


%%Add door

%3DHome door
filepaths = string('3dhome/door.ply');
door3DStruct = loadAndMergeModels(filepaths);

%Magichouse door
filepaths = string('magichouse/door.ply');
doorMagicStruct = loadAndMergeModels(filepaths);
filepaths = string('magichouse/doorcon.ply');
doorconMagicStruct = loadAndMergeModels(filepaths);

%Decide on shape examples
wallBaseShape = door3DStruct.vertices;
newModelShape = doorconMagicStruct.vertices;

%Fit model shape to base shape
M = fitToWall(newModelShape, wallBaseShape, normal);

%Get contour and move to wall
newModelContour = extractSimplifiedContour3D(newModelShape, normal);
newModelContour = applyTransformation(newModelContour, M);

%Constrain contour
[newModelContour, T] = constrainContour(wallFrontStruct.vertices, newModelContour, up);
M = T*M;

%Carve door shape into front wall
[wallFrontStruct, holeStruct] = createHoleFromContour(wallFrontStruct, newModelContour);
holeStructs = [holeStruct];

%Retriangulate
wallFrontStruct = retriangulateWall(wallFrontStruct, holeStructs);
wallLeftStruct = retriangulateWall(wallLeftStruct);
wallRightStruct = retriangulateWall(wallRightStruct);
wallRightStruct = retriangulateWall(wallRightStruct);
wallBackStruct = retriangulateWall(wallBackStruct);

%Insert door into front wall
doorMagicStruct.vertices = applyTransformation(doorMagicStruct.vertices, M);
%wallFrontStruct = mergeModels(wallFrontStruct, doorMagicStruct);

%Merge front wall with rest of building
fullHouseStruct = mergeModels([wallFrontStruct, wallLeftStruct, wallRightStruct, wallBackStruct]);

%Merge in roof
fullHouseStruct = mergeModels([fullHouseStruct, roofMagicStruct]);

%Output
write_ply(fullHouseStruct.vertices, fullHouseStruct.faces,'test.ply','ascii');