magicHouse = loadAndPrepareModelFolder('testMagicHouse');
magicFoundationStructs = magicHouse.foundation.models;
curves = getFoundationCurves(magicFoundationStructs);

%Make a new foundation
foundationStructs = buildAnySidedFoundation(3, 40000, 10000, 10000);
foundationStructs = curveWalls(foundationStructs, curves);
foundationStruct = mergeModels(foundationStructs);

write_ply(foundationStruct.vertices, foundationStruct.faces, 'test.ply');