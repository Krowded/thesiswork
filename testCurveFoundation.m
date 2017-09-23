found1 = mergeModels(found);

%Merge frontIndices
found1.frontIndices = found(1).frontIndices;
prev = size(found(1).vertices,1);
for i = 2:length(found)
    found1.frontIndices = [found1.frontIndices; (found(i).frontIndices + prev)];
    prev = prev + size(found(i).vertices,1);
end

%Curve frontVertices
model = found1; 
modelOut = model;
modelOut.vertices = model.vertices(model.frontIndices,:);
modelOut = curveModelCombined(modelOut, foundationCurves);
model.vertices(model.frontIndices,:) = modelOut.vertices;
write_ply(model.vertices, model.faces, 'test.ply')