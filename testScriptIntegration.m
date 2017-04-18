%Get models

%3DHome roof
filepaths = [string('3dhome/roofLeft.ply');
             string('3dhome/roofRight.ply')];
[roof3Dvert, roof3Dface] = loadAndMergeModels(filepaths);

%3DHome foundation
filepaths = [string('3dhome/wallFront.ply') 
             string('3dhome/wallLeft.ply')
             string('3dhome/wallRight.ply')
             string('3dhome/wallBack.ply')];
[foundation3Dvert, foundation3Dface] = loadAndMergeModels(filepaths);

%Get front wall for door insertion (ugly)
[tempvert, tempface] = loadAndMergeModels(string('3dhome/wallFront.ply'));
wallFrontIndices = 1:size(tempvert,1);
wallFrontFaceIndices = 1:size(tempface,1);

%3DHome door
filepaths = string('3dhome/door.ply');
[door3Dvert, door3Dface] = loadAndMergeModels(filepaths);

%MagicHouse roof
filepaths = [string('magichouse/roofLeft.ply')
             string('magichouse/roofRight.ply')];
[roofMagicvert, roofMagicface] = loadAndMergeModels(filepaths);

%MagicHouse foundation
filepaths = [string('magichouse/wallFront.ply')
             string('magichouse/wallLeft.ply')
             string('magichouse/wallRight.ply')
             string('magichouse/wallBack.ply')];
[foundationMagicvert, foundationMagicface] = loadAndMergeModels(filepaths);

%Magichouse door
filepaths = string('magichouse/door.ply');
[doorMagicvert, doorMagicface] = loadAndMergeModels(filepaths);
filepaths = string('magichouse/doorcon.ply');
doorconMagicvert = loadAndMergeModels(filepaths);

%Set normal (TODO)
normal = [-1,0,0];
up = [0, 1, 0];
side = [0, 0, 1];

%Names
roof1vert = roof3Dvert;
roof1face = roof3Dface;
found1vert = foundation3Dvert;
found1face = foundation3Dface;

roof2vert = roofMagicvert;
roof2face = roofMagicface;
found2vert = foundationMagicvert;
found2face = foundationMagicface;

% roof2vert = roof3Dvert;
% roof2face = roof3Dface;
% found2vert = foundation3Dvert;
% found2face = foundation3Dface;
% 
% roof1vert = roofMagicvert;
% roof1face = roofMagicface;
% found1vert = foundationMagicvert;
% found1face = foundationMagicface;


%Get slots from foundation
roof1Slots = slotsFromRoofFoundationIntersection(roof1vert, found1vert, normal, up);
roof2Slots = slotsFromRoofFoundationIntersection(roof2vert, found2vert, normal, up);

%Calculate non-uniform scaling
S = scaleMatrixFromSlots(roof2Slots, roof1Slots, normal, up);
roof2Slots = applyTransformation(roof2Slots, S);

%Slot fitting
[regParams,Bfit,ErrorStats] = absor(roof2Slots', roof1Slots', 'doScale', 0, 'doTrans', 1);

%Apply complete transformation
M = regParams.M;
M = M*S;
roof2vert = applyTransformation(roof2vert, M);

%Get roof curve
curveFunction = getCurveUnderModel(roof2vert, side, up, normal);

%Get normals here since curvefitting messes up faces
wallFrontNormals = calculateNormals(found1vert(wallFrontIndices,:),found1face(wallFrontFaceIndices,:));

%Fit foundation to curve
%NEED TO INTRODUCE MORE VERTICES IF TOO SIMPLE
found1vert = fitFoundationToCurve(found1vert, roof1Slots, curveFunction, side, up);

%Extract front wall
wallFrontvert = found1vert(wallFrontIndices,:);
wallFrontface = found1face(wallFrontFaceIndices,:);
found1vert(wallFrontIndices,:) = [];
found1face(wallFrontFaceIndices,:) = [];
found1face = found1face - size(wallFrontvert,1);

%Carve door shape into front wall
[wallFrontvert, wallFrontface, M] = carveShapeIntoWall(wallFrontvert, wallFrontface,...
                                                       doorconMagicvert, door3Dvert,...
                                                       normal, up,...
                                                       wallFrontNormals);
                                                   
%Insert door into front wall
doorMagicvert = applyTransformation(doorMagicvert, M);
[wallFrontvert, wallFrontface] = mergeModels(wallFrontvert, wallFrontface, doorMagicvert, doorMagicface);

%Merge front wall with rest of building
[found1vert, found1face] = mergeModels(wallFrontvert, wallFrontface, found1vert, found1face);

%Merge in roof
[vert, face] = mergeModels(found1vert, found1face, roof2vert, roof2face);

%Output
write_ply(vert,face,'test.ply','ascii');