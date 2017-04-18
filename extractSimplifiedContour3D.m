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
    flatVertices = vertices(:,1:2);

    %Extract contour
    [flatVertices, tempIndices] = extractSimplifiedContour2D(flatVertices);    
    indices = optional_indices(tempIndices);
    
    %Extract depth and extend back to 3D 
    depth = getMiddleOfObjectDepth(vertices(indices,:), [0, 0, 1]); %Normal is always Z here because of basis change
    flatVertices(:,3) = depth;
    
    %Change basis back
    vertices = matrixMultByRow(flatVertices, B);
end