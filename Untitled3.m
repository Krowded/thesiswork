model = loadAndMergeModels('D:\School\Thesis\Matlabtest\Archive\EB-112high.ply');
model.upVector = [0 1 0];

curves = foundationCurves;
curves(3) = curves(1);
curves(3).normal = -curves(3).normal;

% R = [1 0 0;
%      0 0 1;
%      0 -1 0];
R = [0 0 -0.001;
     0 0.001 0;
     0.001 0 0];
for i = 1:size(model.vertices,1)
    model.vertices(i,:) = (R*model.vertices(i,:)')';
end

model = curveModelCombined(model, curves);
write_ply(model.vertices, model.faces, 'test.ply');
