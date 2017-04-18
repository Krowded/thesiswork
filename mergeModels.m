function [mergedVertices, mergedFaces] = mergeModels(model1Vertices, model1Faces, model2Vertices, model2Faces)
    mergedVertices = [model1Vertices; model2Vertices];    
    mergedFaces = [model1Faces; model2Faces + size(model1Vertices,1)];
end