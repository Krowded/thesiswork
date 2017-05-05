magicFoundation = findFirst([string('name'), string('style')], [string('foundation'), string('magic')]);
magicRoof = findFirst([string('name'), string('style')], [string('roof'), string('magic')]);
magicDoor = findFirst([string('name'), string('style')], [string('door'), string('magic')]);

%Turn curve vertices into curveFunction
for i = 1:length(magicFoundation.curves)
    magicFoundation.curves(i).curveFunction = @(xq) interp1(magicFoundation.curves(i).vertices(:,2), magicFoundation.curves(i).vertices(:,1), xq, 'linear', 'extrap');
end

%Make a new foundation
spans = zeros(size(magicFoundation.curves));
for i = 1:length(magicFoundation.curves)
    spans(i) = magicFoundation.curves(i).span;
end
spans = sort(spans, 'descend');
numberOfWalls = 4;
radius = 40000;
height = 10000;
wallThickness = (height/100)*(spans(1)+spans(2)); %Maximum movement of walls from curve (unless walls get taller... which they do)
foundationStructs = buildAnySidedFoundation(numberOfWalls, radius, height, wallThickness);

% % Add roof positioning slots
roofSlots = [-radius, height, -radius;
              radius, height, -radius;
              radius, height,  radius;
             -radius, height,  radius;];
%              -radius, 2*height, -radius;
%               radius, 2*height, -radius;
%               radius, 2*height,  radius;
%              -radius, 2*height,  radius;];

%Match roof slots
M = matchSlots(magicRoof.slots, roofSlots, 'uniform', [0, 0, 1], [0, 1, 0]);
newRoofStruct = loadAndMergeModels(magicRoof.filepaths);
newRoofStruct.slots = applyTransformation(magicRoof.slots, M);
newRoofStruct.vertices = applyTransformation(newRoofStruct.vertices, M);

%Fit foundation to roof curve
lowestChangableHeight = min(roofSlots*foundationStructs(1).upVector');
changedAndNewIndices = cell(1,length(foundationStructs));
for i = 1:length(foundationStructs)
    %TODO: CHANGE CURVE CALCULATION TO LINE-TRIANGLE INTERSECTION WITH A SUBSET OF FACES FOR EXACT VALUES (PROBABLY SLOWER THOUGH)
    curveStruct = getCurveUnderRoof(newRoofStruct, foundationStructs(i));
    curveStructs(i) = curveStruct;
    [foundationStructs(i), changedAndNewIndices{i}] = fitWallToRoofCurve(foundationStructs(i), lowestChangableHeight, curveStruct.curveFunction, curveStruct.curveLength);
end



%Create door positioning slots
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
doorSlots = [minX maxY maxZ;
             maxX maxY maxZ;
             maxX minY maxZ;
             minX minY maxZ;
             minX maxY minZ;
             maxX maxY minZ;
             maxX minY minZ;
             minX minY minZ];


%Match door slots
M = matchSlots(magicDoor.slots, doorSlots, 'uniform');

%Get contour and move to wall
newModelContour = magicDoor.contour;
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
foundationStructs = curveWalls(foundationStructs, magicFoundation.curves);

%Insert door into model
foundationStruct = mergeModels(foundationStructs);
door2 = loadAndMergeModels(magicDoor.filepaths);
door2.vertices = applyTransformation(door2.vertices, M);
foundationStruct = mergeModels([foundationStruct door2]);
foundationStruct = mergeModels([foundationStruct newRoofStruct]);

write_ply(foundationStruct.vertices, foundationStruct.faces, 'test.ply');