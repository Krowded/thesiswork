%Create a new foundation
[foundationStructs, connectionStructs] = newFoundation();

%Select style
style = [string('cathedral')];

%Extract names
partClasses = string.empty;
for i = 1:length(connectionStructs)
    partClasses(i) = string(connectionStructs(i).class);
end

[foundationCurves, roofStruct, partsStructs] = findStyle(style, partClasses);

for i = 1:length(partsStructs)
    slotType = strsplit(partsStructs{i}.slotType,'-');
    if strcmp(slotType{1}, 'surround') || strcmp(slotType{1}, 'intersect')
        newConnection = newConnectionStruct();
        newConnection.name = partsStructs{i}.name;
        newConnection.class = partsStructs{i}.class;
        newConnection.connectedWall = [];
        newConnection.slots = partsStructs{i}.slots;
        newConnection.type = 'nocut';
        newConnection.frontVector = partsStructs{i}.frontVector;
        newConnection.upVector = partsStructs{i}.upVector;
        connectionStructs(end+1) = newConnection;
    end
end

%Transfer style onto foundation
for i = 1:length(foundationCurves)
    foundationCurves(i).otherDirection = [0 1 0];
end
buildingModel = buildCompleteStructure(foundationStructs, connectionStructs, foundationCurves, roofStruct, partsStructs);

%Add floor
% corner = 1000000;
% floorVertices = [-corner, 0,  corner;
%                   corner, 0,  corner;
%                   corner, 0, -corner;
%                  -corner, 0, -corner];
% floorFaces = [1 2 3; 1 3 4];
% buildingModel.faces = [buildingModel.faces; floorFaces + size(buildingModel.vertices,1)];
% buildingModel.vertices = [buildingModel.vertices; floorVertices];


%Write model to file
% buildingModel = mergeModels(foundationStructs)
write_ply(buildingModel.vertices, buildingModel.faces, 'test.ply');