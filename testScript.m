%Get wall
[vert, face] = read_ply('backtop.ply');

%Set normal (TODO)
normal = [-1,0,0];

%Get contour
[door, doorface] = read_ply('door.ply');
doorcon = read_ply('doorcon.ply');
doorcon = extractSimplifiedContour3D(doorcon, normal);

%Move contour to nice place (slot fitting and scaling later)
T = [ 1, 0, 0, -100;
      0, 1, 0,  5;
      0, 0, 1,  0;
      0, 0, 0,  1];
for i = 1:size(doorcon,1)
    temp = [doorcon(i,:), 1];
    temp = (T*temp')';
    doorcon(i,:) = temp(1:3);
end
doorconFront =  doorcon;
doorconBack = doorcon;

% %Adjust front depth
normals = calculateNormals(vert, face);
frontFaces = getSameDirectionFaceIndices(normals, normal);
intersectedFaces = raysFacesIntersect(vert, face, doorconFront, normal, 1, frontFaces);
depth = mean(vert(unique(face(intersectedFaces,:)),:)*normal');
if isempty(intersectedFaces)
    warning('no intersected faces')
    depth = 0;
end
doorconFront = doorconFront - normal.*(doorconFront*normal') + normal.*depth;
%Adjust back depth
backFaces = getSameDirectionFaceIndices(normals, -normal);
intersectedFaces = raysFacesIntersect(vert, face, doorconBack, -normal, 1, backFaces);
depth = mean(vert(unique(face(intersectedFaces,:)),:)*normal');
if isempty(intersectedFaces)
    warning('no intersected faces')
    depth = 0;
end
doorconBack = doorconBack - normal.*(doorconBack*normal') + normal.*depth;

% %Find previous holes in the wall
% [holeIndices, lengthsOfHoles] = findHoles(vert,face,normal);
% holesToRemove = [];
% [holeIndices, lengthsOfHoles] = removeHoles(holeIndices, lengthsOfHoles, holesToRemove);
holeIndices = [];%realignHoleIndices(vert, holeIndices, lengthsOfHoles, normal);
lengthsOfHoles = [];

%Insert door contour into list of holes
holeIndices = [holeIndices; ((size(vert,1)+1):(size(vert,1)+(2*size(doorcon,1))))'];
lengthsOfHoles = [lengthsOfHoles size(doorcon,1)];
vert = [vert; doorconFront; doorconBack];

%Retriangulate
[vert,face] = createNewHoles(vert, face, holeIndices, lengthsOfHoles, normal); %We lose non-hole vertices. Look into it!

T = [ 1, 0, 0, -1;
      0, 1, 0,  5;
      0, 0, 1,  0;
      0, 0, 0,  1];
for i = 1:size(door,1)
    temp = [door(i,:), 1];
    temp = (T*temp')';
    door(i,:) = temp(1:3);
end

face = [face; doorface+size(vert,1)];
vert = [vert; door];

%Output
write_ply(vert,face,'test.ply','ascii');