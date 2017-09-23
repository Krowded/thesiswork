modelExample = loadAndMergeModels('D:\School\Thesis\Paper code\Shape transfer\case1\raw-part\F89\F89-2\8.ply');
modelTarget = loadAndMergeModels('ex1\Bedside_table.ply');
upVector = [0 1 0];

clear newCurves;
clear oppositeOldCurves;
directions = [ 1 0  0;
               0 0  1;
              -1 0  0;
               0 0 -1];

index = 1;
for i = 1:4
    verts = getCurveVertices(modelExample.vertices, directions(i,:), upVector);
    if size(verts,1) < 3 %We should just ignore instances with no actual curve
        continue;
    end
    newCurves(index).vertices = verts;
    max(verts(:,1))
    min(verts(:,1))
    newCurves(index).normal = directions(i,:)';
    newCurves(index).curveFunction = @(xq) interp1(newCurves(i).vertices(:,2), newCurves(i).vertices(:,1), xq, 'linear', 'extrap');
    index = index + 1;
end


for i = 1:4
    oppositeOldCurves(i).normal = directions(i,:)';
    oppositeOldCurves(i).vertices = getCurveVertices(modelTarget.vertices, oppositeOldCurves(i).normal', upVector);
    oppositeOldCurves(i).vertices
    oppositeOldCurves(i).curveFunction = @(xq) interp1(oppositeOldCurves(i).vertices(:,2), -oppositeOldCurves(i).vertices(:,1), xq, 'linear', 'extrap');
end

modelTarget = curveModelCombined(modelTarget, oppositeOldCurves, upVector);
modelTarget = curveModelCombined(modelTarget, newCurves, upVector);
write_ply(modelTarget.vertices, modelTarget.faces, 'test/test.ply');