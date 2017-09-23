modelTarget = loadAndMergeModels('Archive\testDoor\door.ply');
modelTarget.upVector = [0 1 0];
modelTarget.frontVector = [0 0 1]; 

modelExample = loadAndMergeModels('Archive\mostmodels\039_Window_low poly.ply');
modelExample.upVector = [0 1 0];
modelExample.frontVector = [1 0 0];

newModel = transferCurve(modelTarget, modelExample);

write_ply(newModel.vertices, newModel.faces, 'test.ply');