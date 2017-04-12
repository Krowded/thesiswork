%Takes indices of a contour in winding order and returns it with the upper
%right corner as the starting point
function [indices] = realignWindingOrder(vertices, indices, normal)
    vertices = vertices(indices, :);
    
    %Flatten
    B = getBaseTransformationMatrix(normal);
    Binv = inv(B);
    vertices = matrixMultByRow(vertices, Binv);
    
    %Find top right corner
    measuringVector = [1, 1, 0];
    indicesTopRight = 0;
    currentMaxRight = -Inf;
    for i = 1:size(indices,1)
        v1 = dot(measuringVector, vertices(i,:));
        if v1 > currentMaxRight
            indicesTopRight = i;
        end
    end

    %Shift so that so that is starts at the top right corner
    tempIndices = indices(indicesTopRight:end);
    indices = [tempIndices; indices(1:(indicesTopRight-1))];
end