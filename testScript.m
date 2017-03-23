%Get wall
[vert, face] = read_ply('frontwall.ply');

%Set normal (TODO)
normal = [-1,0,0];

% %Get contour
door = read_ply('door.ply');
doorcon = extractSimplifiedContour3D(door, normal);

%Move contour to nice place (slot fitting and scaling later)
T = [ 10, 0, 0, -100;
      0, 10, 0, 60;
      0, 0, 10, 50;
      0, 0, 0, 10];
for i = 1:size(doorcon,1)
    temp = [doorcon(i,:), 1];
    temp = (T*temp')';
    doorcon(i,:) = temp(1:3);
end

%Insert hole into wall
[holeIndices, lengthsOfHoles] = findHoles(vert,face,normal);
holeIndices = [holeIndices; holeIndices; ((size(vert,1)+1):(size(vert,1)+(2*size(doorcon,1))))'];
lengthsOfHoles = [lengthsOfHoles size(doorcon,1)];
vert = [vert; doorcon; doorcon];
[vert,face] = createNewHoles(vert, face, holeIndices, lengthsOfHoles, normal);
%[vert,face] = createNewHole(vert, face, doorcon, normal);

%Output
write_ply(vert,face,'test.ply','ascii');