function roofModel = loadRoof(roofStruct, simplificationFactor)
    if nargin < 2
        simplificationFactor = 1e-2;
    end
    
    for i = 1:length(roofStruct.models)
        %Load
        models(i) = loadAndMergeModels(roofStruct.models(i).filepaths);        
        models(i).upVector = roofStruct.models(i).upVector';
        models(i).frontVector = roofStruct.models(i).frontVector';
        
        %Simplify/Fuse
%         [models(i).vertices, ~, SVJ] = remove_duplicate_vertices(models(i).vertices, simplificationFactor);
%         models(i).faces = SVJ(models(i).faces);
%         [models(i).vertices, models(i).faces] = remove_degenerate_faces(models(i).vertices, models(i).faces);
%         models(i).faces = removeSingularFaces(models(i).faces);
    end
    
    roofModel = mergeModels(models);
    roofModel.slots = roofStruct.slots;
end