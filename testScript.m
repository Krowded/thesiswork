%Get wall
[vert, face] = read_ply('3dhome/wallFront.ply');

%Set normal (TODO)
normal = [-1,0,0];
up = [0, 1, 0];
groundLevel = min(vert*up');

%Get contour
[door, doorface] = read_ply('door.ply');
doorcon = read_ply('doorcon.ply');
doorconSlots = slotsFromModel(doorcon, normal);
doorcon = extractSimplifiedContour3D(doorcon, normal);

%Wall slot placement
wallcon = read_ply('shittydoor.ply');
wallSlots = slotsFromModel(wallcon,normal);

%Slot fitting
[regParams,Bfit,ErrorStats] = absor(doorconSlots',wallSlots', 'doScale', 1, 'doTrans', 1);
M = regParams.M;
doorcon = applyTransformation(doorcon, M);

%Check if any below ground and move them up 
% [Expand this to keep things inside target walls entirely]
% [Alternatively allow for a lot of non-uniform scaling]
t = constrainAboveGround(doorcon, up, groundLevel);
T = getTranslationMatrixFromVector(t);
doorcon = applyTransformation(doorcon,T);
M = T*M;

%Create new vertices for front and back part of wall
normals = calculateNormals(vert, face);
frontDepth = getDepthOfSurface(doorcon, vert, face, normals, normal);
backDepth = -getDepthOfSurface(doorcon, vert, face, normals, -normal); %Negative normal gives negative depth
doorconFront = doorcon - normal.*(doorcon*normal') + normal.*frontDepth;
doorconBack = doorcon - normal.*(doorcon*normal') + normal.*backDepth;

%Set up list of holes
holeIndices = [];
lengthsOfHoles = [];

%Insert door contour into list of holes
doorconHoleVertices = [doorconFront; doorconBack];
[vert, holeIndices, lengthsOfHoles] = insertNewHole(vert, holeIndices, lengthsOfHoles, doorconHoleVertices);

%Retriangulate
[vert,face] = createNewHoles(vert, face, holeIndices, lengthsOfHoles, normal); %We lose non-hole vertices. Look into it!

%Insert door model
door = applyTransformation(door, M);
face = [face; doorface+size(vert,1)];
vert = [vert; door];

%Output
write_ply(vert,face,'test.ply','ascii');