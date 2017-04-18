%Take the vertices of a new hole and appends them to the list. Assumes two
%levels (i.e. an equal number of front and a back vertices given)
function [vertices, holeIndices, lengthsOfHoles] = insertNewHole(vertices, holeIndices, lengthsOfHoles, newHoleVertices)
    holeLength = size(newHoleVertices,1)/2;
    holeIndices = [holeIndices; ((size(vertices,1)+1):(size(vertices,1)+(2*holeLength)))'];
    lengthsOfHoles = [lengthsOfHoles holeLength];

    %Insert corresponding vertices into vertex list
    vertices = [vertices; newHoleVertices];
end