%Create a new foundation
[foundationStructs, connectionStructs] = newFoundation();

%Select style
style = string('magic');

%Extract names
partNames = string.empty;
for i = 1:length(connectionStructs)
    partNames(i) = string(connectionStructs(i).name);
end

[foundationCurves, roofStruct, partsStructs] = findStyle(style, partNames);

%Transfer style onto foundation
buildingModel = buildCompleteStructure(foundationStructs, connectionStructs, foundationCurves, roofStruct, partsStructs);

%Write model to file
write_ply(buildingModel.vertices, buildingModel.faces, 'test.ply');