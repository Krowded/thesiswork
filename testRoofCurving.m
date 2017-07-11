%Original
model2 = model.roof.models(2);
write_ply(model2.vertices, model2.faces, 'testOriginal.ply');

%Change curve
model2 = curveRoof(model2, foundationCurves, 1);

%Fix any overlap
% max(model2.vertices*model2.upVector')
% limit
% if max(model2.vertices*model2.upVector') > limit
%     model2 = fixOverCurving(model2, slot, -forward);
% end

%Write to file
write_ply(model2.vertices, model2.faces, 'testNewRight.ply');