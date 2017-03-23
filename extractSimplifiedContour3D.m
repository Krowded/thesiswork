%Does the same thing as extractContour3D but also removes redundant vertices
function [vertices,indices] = extractSimplifiedContour3D(vertices, normal, optional_indices)
    %Adjust for optional arguments
    if nargin < 3
        optional_indices = 1:size(vertices,1);
    else
        vertices = vertices(optional_indices,:);
    end
    
    %Normalize for safety
    normal = normalize(normal);
    
    %Change basis
    B = getBaseTransformationMatrix(normal);
    Binv = inv(B);
    vertices = matrixMultByRow(vertices, Binv);
      
    %Flatten to 2D
    vertices = vertices(:,1:2);

    %Extract contour
    [vertices, tempIndices] = extractSimplifiedContour2D(vertices);    
    indices = optional_indices(tempIndices);
    
    %Extend back to 3D
    vertices(:,3) = 0;
    
    %Change basis back
    vertices = matrixMultByRow(vertices, B);
end