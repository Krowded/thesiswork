%Returns a base transformation matrix that moves the normal to the z-vector
function [baseTransformationMatrix] = getBaseTransformationMatrix(normal)
     normal = normalize(normal);
     temp = [1, 0, 0];
     if norm(cross(normal,temp)) < 0.0001
         temp = [0, 1, 0];
     end
     base1 = normalize(cross(normal, temp));
     base2 = normalize(cross(normal, base1));
     baseTransformationMatrix = [base1' base2' normal'];
end