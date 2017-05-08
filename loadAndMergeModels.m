function [model, subModelVertexSizes, subModelFaceSizes] = loadAndMergeModels(filepaths)
    model = newModelStruct([], [], [], []);
    subModelVertexSizes = [];
    subModelFaceSizes = [];
    filepaths = string(filepaths); %Cause blaha...
    for i = 1:length(filepaths)
        [tempVertices, tempFaces] = read_ply(filepaths(i));
        tempModel = newModelStruct(tempVertices, tempFaces);
        model = mergeModels([model, tempModel]);
        subModelVertexSizes(i) = size(tempVertices,1);
        subModelFaceSizes(i) = size(tempFaces,1);
    end
end