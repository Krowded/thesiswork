% x = normalize([0 56.7840 88.5324]); %normal left
% x = normalize([0   57.7930  -93.8036]); %normal right
% x = normalize([0 13.5853 9.5066]); %magic left
x = normalize([-0.1003   14.1096   -9.0456]); %magic right
y = -cross(x, [1 0 0]);
model.upVector = x;
model.frontVector = -y; %Turn around frontVector to get curve from the back of roof instead of front
curve = getWallCurve(model);
model.frontVector = y;
curveFunction = @(xq) interp1(curve.vertices(:,2), curve.vertices(:,1), xq, 'linear', 'extrap');

[limit,I] = max(model.vertices*x');
slot = model.vertices(I,:);

%Original
model2 = model;
write_ply(model2.vertices, model2.faces, 'testOriginal.ply');

%Remove curve
minHeight = min(model2.vertices*model2.upVector');
maxHeight = max(model2.vertices*model2.upVector');
model2.vertices = curveVertices(model2.vertices, curveFunction, x, y, minHeight, maxHeight);
write_ply(model2.vertices, model2.faces, 'test.ply');

%Add new curve
minHeight = min(model2.vertices*model2.upVector');
maxHeight = max(model2.vertices*model2.upVector');
model2.vertices = curveVertices(model2.vertices, foundationCurves(2).curveFunction, x, y, minHeight, maxHeight);
model2.vertices = curveVertices(model2.vertices, foundationCurves(2).curveFunction, x, y, minHeight, maxHeight);
model2.vertices = curveVertices(model2.vertices, foundationCurves(2).curveFunction, x, y, minHeight, maxHeight);

%Fix any overlap
if max(model2.vertices*model2.upVector') > limit
    model2 = fixOverCurving(model2, slot);
end

%Write to file
write_ply(model2.vertices, model2.faces, 'testNewRight.ply');

%REMEMBER TO FIX SLOTS ETC BEFORE CALLING IT DONE