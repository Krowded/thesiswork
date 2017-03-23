%Just multiplies the basematrix
function [vertices] = revertBasis(vertices, baseMatrix)
    for i = 1:size(vertices,1)
        vertices(i,:) = (baseMatrix*vertices(i,:)')';
    end
end