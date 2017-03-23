%Removes all unreferenced vertices
function [vertices, faces] = removeUnreferencedVertices(vertices, faces)
    allIndices = 1:size(vertices,1);
    [~,removableIndices] = setdiff(allIndices, faces(:),'stable');
    [vertices, faces] = removeVerticesSimple(vertices, faces, removableIndices);
end