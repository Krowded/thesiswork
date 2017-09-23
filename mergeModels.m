%Appends one model to another
%Keeps all other values from the first model in the list
function [model] = mergeModels(models)
    model = models(1);
    for i = 2:length(models)
        model.faces = [model.faces; models(i).faces + size(model.vertices,1)];
        model.vertices = [model.vertices; models(i).vertices];
        model.faceNormals = [model.faceNormals; models(i).faceNormals];
        model.slots = [model.slots; models(i).slots];
    end
end