%Takes vertices, a normal and optionally indices, and returns the vertices
%of the 2D convex hull with a normal equal to the normal argument in order. 
%It also returns the original indices of those vertices.
function [vertices,indices] = extractContour3D(vertices, normal, indices)
    %Adjust for optional arguments
    if exist('indices', 'var')
        vertices = vertices(indices,:);
    else
        indices = 1:size(vertices,1);
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
    [flatVertices, indices] = extractContour2D(flatVertices, indices);
    
    %Extend back to 3D
    %flatVertices(:,3) = 0;
    %Extract depth?
    depth = getMiddleOfObjectDepth(vertices(indices,:), [0,0,1]);
    flatVertices(:,3) = depth;
    
    %Change basis back
    vertices = matrixMultByRow(flatVertices, B);
end