%Takes a vector of vertices and a 4 by 4 transformation matrix and applies
%the transformation to each vertexs
function vertices = applyTransformation(vertices, transformationMatrix)
    for i = 1:size(vertices,1)
        temp = [vertices(i,:), 1];
        temp = (transformationMatrix*temp')';
        vertices(i,:) = temp(1:3);
    end
end