%Take the vertices of a new hole and appends them to the list. Assumes two
%levels (i.e. an equal number of front and a back vertices given)
function [vertices, holeStruct] = insertNewHole(vertices, holeFrontVertices, holeBackVertices)
    if size(holeFrontVertices,1) ~= size(holeBackVertices,1)
        error('Front and back of hole need to be same size');
    end
    
    %Append front vertices
    currentVerticesSize = size(vertices,1);
    frontIndices = (1:size(holeFrontVertices,1)) + currentVerticesSize;
    vertices = [vertices; holeFrontVertices];
    
    %Append back vertices
    currentVerticesSize = size(vertices,1);
    backIndices = (1:size(holeBackVertices,1)) + currentVerticesSize;
    vertices = [vertices; holeBackVertices];

    %Create return structure
    holeStruct = newHoleStruct(frontIndices, backIndices);
end