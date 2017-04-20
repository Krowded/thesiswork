%Just multiplies every row by the matrix
function [vertices] = matrixMultByRow(vertices, matrix)
    for i = 1:size(vertices,1)
        vertices(i,:) = (matrix*vertices(i,:)')';
    end
end