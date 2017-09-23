mergeFolder = string('test\');
mergeFile = mergeFolder + string('merge.txt');
mergeInfo = loadMergeFolder(mergeFile);
exemplarFolder = loadModelFolder(mergeFolder + mergeInfo.targetFolder);
targetFolder = loadModelFolder(mergeFolder + mergeInfo.exemplarFolder);

fullModel = newModelStruct();
for j = 1:size(mergeInfo.parts,1)
    modelTarget = loadAndMergeModels(targetFolder.(char(mergeInfo.parts(j,1))).filepaths);
    modelTarget.upVector = targetFolder.(char(mergeInfo.parts(j,1))).upVector;
    modelTarget.frontVector = targetFolder.(char(mergeInfo.parts(j,1))).frontVector;
    modelTarget.slots = slotsFromModel(modelTarget);
    
    modelExample = loadAndMergeModels(exemplarFolder.(char(mergeInfo.parts(j,2))).filepaths);
    modelExample.upVector = exemplarFolder.(char(mergeInfo.parts(j,2))).upVector;
    modelExample.frontVector = exemplarFolder.(char(mergeInfo.parts(j,2))).frontVector;
    modelExample.slots = slotsFromModel(modelExample);
    
%     modelTarget = transferCurve(modelTarget, modelExample);
    M = matchSlots(modelTarget.slots, modelExample.slots, 'non-uniform', modelTarget.frontVector, modelTarget.upVector);
    modelTarget.vertices = applyTransformation(modelTarget.vertices, M);
    
    fullModel = mergeModels([fullModel, modelTarget]);
end

body = loadAndMergeModels(mergeFolder + string('ex1\body.ply'));
body.upVector = [1 0 0];
body.frontVector = [0 0 1];

tableTop = loadAndMergeModels(mergeFolder + string('ex2\tableTop.ply'));
tableTop.upVector = [1 0 0];
tableTop.frontVector = [0 0 1];

body = transferCurve(body, tableTop, [0 1 0], [0 1 0]);

fullModel = mergeModels([fullModel, body]);
write_ply(fullModel.vertices, fullModel.faces, 'test\test.ply')


