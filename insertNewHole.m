%Take the vertices of a new hole and appends them to the list. Assumes two
%levels (i.e. an equal number of front and a back vertices given)
function [wallStruct, holeStruct] = insertNewHole(wallStruct, holeFrontVertices, holeBackVertices)
    if size(holeFrontVertices,1) ~= size(holeBackVertices,1)
        error('Front and back of hole need to be same size');
    end
    
    %Append front vertices
    currentVerticesSize = size(wallStruct.vertices,1);
    frontHoleIndices = ((1:size(holeFrontVertices,1)) + currentVerticesSize)';
    wallStruct.frontIndices = [wallStruct.frontIndices; frontHoleIndices];
    wallStruct.vertices = [wallStruct.vertices; holeFrontVertices];
    
    %Append back vertices
    currentVerticesSize = size(wallStruct.vertices,1);
    backHoleIndices = ((1:size(holeBackVertices,1)) + currentVerticesSize)';
    wallStruct.backIndices = [wallStruct.backIndices; backHoleIndices];
    wallStruct.vertices = [wallStruct.vertices; holeBackVertices];

    %Create return structure
    holeStruct = newHoleStruct(frontHoleIndices, backHoleIndices);
end