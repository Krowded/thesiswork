%Original
[curves, model] = findStyle(string('magic'), string('roof'));
model2 = loadAndMergeModels(model.models(1).filepaths);
model2.upVector = model.models(1).upVector';
model2.frontVector = model.models(1).frontVector';

write_ply(model2.vertices, model2.faces, 'testOriginal.ply');

%Change curve
model2 = curveRoof(model2, curves, 0);

%Fix any overlap
% max(model2.vertices*model2.upVector'
% limit
% if max(model2.vertices*model2.upVector') > limit
%     model2 = fixOverCurving(model2, slot, -forward);
% end

%Write to file
write_ply(model2.vertices, model2.faces, 'testNewRight.ply');