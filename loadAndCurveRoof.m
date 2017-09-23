function roofModel = loadAndCurveRoof(roofStruct, curveStructs, iterations, simplificationFactor)
    if nargin < 4    
        simplificationFactor = 1e-2;
    end
    if nargin < 3
        iterations = 1;
    end
    
    

    models = [];
    for i = 1:length(roofStruct.models)
        %Load
        model = loadAndMergeModels(roofStruct.models(i).filepaths);        
        model.upVector = roofStruct.models(i).upVector';
        model.frontVector = roofStruct.models(i).frontVector';
        
        %Simplify/Fuse
        [model.vertices, ~, SVJ] = remove_duplicate_vertices(model.vertices, simplificationFactor);
        model.faces = SVJ(model.faces);
        [model.vertices, model.faces] = remove_degenerate_faces(model.vertices, model.faces);
        model.faces = removeSingularFaces(model.faces);
        
        %Curve
        curveFunction = collectCurves(curveStructs, model.frontVector);
        models = [models curveRoof(model, curveFunction, iterations)]; %TODO: ADD UPWARDS CURVE
    end
    
    roofModel = mergeModels(models);
end