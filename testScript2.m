%Get roof
[vert, face] = read_ply('roof2.ply');

%Set normal (TODO)
normal = [-1,0,0];
up = [0, 1, 0];

%Get contour
[chimney, chimneyface] = read_ply('chimney1.ply');
chimneycon = read_ply('chimney1.ply');
chimneyconSlots = slotsFromModel(chimneycon, up, normal); %Switch around up and normal for chimney
chimneycon = extractSimplifiedContour3D(chimneycon, up);

%Wall slot placement
wallcon = read_ply('chimney2.ply');
%wallcon = extractSimplifiedContour3D(wallcon, up);
wallSlots = slotsFromModel(wallcon, up, normal);

%Slot fitting
[regParams,Bfit,ErrorStats] = absor(chimneyconSlots',wallSlots', 'doScale', 1, 'doTrans', 1);
M = regParams.M;
chimneycon = applyTransformation(chimneycon, M);

%Insert model
chimney = applyTransformation(chimney, M);
face = [face; chimneyface+size(vert,1)];
vert = [vert; chimney];

%Output
write_ply(vert,face,'test.ply','ascii');