function [vertices, faces] = loadAndMergeModels(filepaths)
    vertices = [];
    faces = [];
    for i = 1:length(filepaths)
        [tempVertices, tempFaces] = read_ply(filepaths(i));
        [vertices, faces] = mergeModels(vertices, faces, tempVertices, tempFaces);
    end
end