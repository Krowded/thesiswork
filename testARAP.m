%Original
[curves, model] = findStyle(string('magic'), string('roof'));
m1 = loadAndMergeModels(model.models(1).filepaths);
m1.upVector = model.models(1).upVector';
m1.frontVector = model.models(1).frontVector';
[m1.vertices,SVI,SVJ] = remove_duplicate_vertices(m1.vertices,1e-2);
m1.faces = SVJ(m1.faces);
[m1.vertices,m1.faces] = remove_degenerate_faces(m1.vertices, m1.faces, 'Epsilon', 0);

m2 = loadAndMergeModels(model.models(2).filepaths);
m2.upVector = model.models(2).upVector';
m2.frontVector = model.models(2).frontVector';
[m2.vertices,SVI,SVJ] = remove_duplicate_vertices(m2.vertices,1e-2);
m2.faces = SVJ(m2.faces);
[m2.vertices,m2.faces] = remove_degenerate_faces(m2.vertices, m2.faces, 'Epsilon', 0);

% m = mergeModels([m1 m2]);

%Collect curves
x = [1 0 0];
z = [0 0 1];
flatForward = normalize([m1.frontVector*x' 0 m1.frontVector*z']);
curveFunction1 = collectCurves(curves, flatForward);
flatForward = normalize([m2.frontVector*x' 0 m2.frontVector*z']);
curveFunction2 = collectCurves(curves, flatForward);

curveHorizontal =  @(xq) interp1([0 50 100], [0 20 0], xq, 'linear','extrap')

%Change curve
m1 = curveRoof(m1, curveFunction1, 1);
m1.upVector = normalize(cross(m1.upVector, m1.frontVector));
m1.frontVector = [0 1 0];
m1 = curveRoof(m1, curveHorizontal, 1);

m2 = curveRoof(m2, curveFunction2, 1);
m2.upVector = normalize(cross(m2.upVector, m2.frontVector));
m2.frontVector = [0 1 0];
m2 = curveRoof(m2, curveHorizontal, 1);

m = mergeModels([m1 m2]);
% write_ply(m.vertices, m.faces, 'testOriginal.ply');



%Doopdidoo
V = m.vertices;
F = m.faces;

%Fuse
[V,SVI,SVJ] = remove_duplicate_vertices(V,1e-2);
F = SVJ(F);
[V,F] = remove_degenerate_faces(V, F, 'Epsilon', 0);
F = removeSingularFaces(F);

write_ply(V, F, 'testComplete.ply');

% bbot = find(V(:,2) < 7.9);
% btop = find(V(:,2) > 17);
% bcbot = V(bbot,:) + [5 -3 0];
% bctop = V(btop,:);
% 
% b = [bbot; btop];
% bc = [bcbot; bctop];

% b = [];
% bc = [];
% 
% [U,data,SS,R] = arap(V,F,b,bc,'Energy','elements', 'V0', mCurve.vertices(SVI,:), 'RemoveRigid', false);
% 
% write_ply(U, F, 'testARAP.ply');