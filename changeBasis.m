function [vertices] = changeBasis(vertices, baseMatrix)
%     for i = 1:size(vertices,1)
%         vertices(i,:) = (baseMatrix\vertices(i,:)')';
%     end
    baseMatrix = inv(baseMatrix);
    baseMatrix(:,4) = [0 0 0];
    baseMatrix(4,:) = [0 0 0 1];
    vertices = applyTransformation(vertices, baseMatrix);
end