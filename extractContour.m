%Takes vertices, a normal and optionally indices, and returns the vertices
%of the 2D convex hull with a normal equal to the normal argument in order. 
%It also returns the original indices of those vertices.
function [vertices,indices] = extractContour(vertices, connections, normal, indices)
    %Adjust for optional arguments
    if exist('indices', 'var')
        vertices = vertices(indices,:);
    else
        indices = 1:size(vertices,1);
    end
    
    %Normalize for safety
    normal = normalize(normal);
    %Change basis so that the normal is the z vector
    if norm(normal - [1, 0, 0]) > 0.0001
        v1 = [1, 0, 0];
    else
        v1 = [0, 0, 1];
    end
    v2 = cross(normal, v1);
    v1 = cross(normal, v2);
    B = [v1(:), v2(:), normal(:)];
    
    for i = 1:size(vertices,1)
        vertices(i,:) = (B\vertices(i,:)')';
    end
    
    %Flatten vertices in the normal direction
    vertices(:,3) = 0;
    
    %Remove duplicates
    tempIndices = 1:size(vertices,1);
    [vertices, tempIndices] = removeDuplicatePoints(vertices, tempIndices);
    indices = indices(tempIndices);  
    
    %Extract contour with Jarvis march/gift wrapping (with extra step of
    %using indices)
    wrappingIndices = NaN(1,size(vertices,1));
    [~,index] = min(vertices(:,1)); %Leftmost point
    pointOnHullIndex = index;
    wrappingIndices(1) = pointOnHullIndex;
    
    endpointIndex = wrappingIndices - 1;
    if endpointIndex == 0 %Since there's no do-while loop this is what we do
        endpointIndex = wrappingIndices(1)+1;
    end
    
    i = 1;
    while endpointIndex ~= wrappingIndices(1)
        wrappingIndices(i) = pointOnHullIndex;
        endpointIndex = 1;
        for j = 2:size(vertices,1)
            if endpointIndex == pointOnHullIndex...
                    || isLeft(vertices(wrappingIndices(i),:), vertices(endpointIndex,:), vertices(j,:))
                endpointIndex = j;
            end
        end
        i = i + 1;
        pointOnHullIndex = endpointIndex;
    end
       
    %Copy to output
    wrappingIndices = wrappingIndices(~isnan(wrappingIndices));
    indices = indices(wrappingIndices);
    vertices = vertices(wrappingIndices,:);
    
    %Change basis back
    for i = 1:size(vertices,1)
        vertices(i,:) = (B*vertices(i,:)')';
    end
end




% %Returns the vertices forming the contour, in wrapping order
% function [vertices] = extractContour(vertices, normal)
%     %Normalize for safety
%     normal = normalize(normal);
%     %Change basis so that the normal is the z vector
%     if norm(normal - [1, 0, 0]) > 0.0001
%         v1 = [1, 0, 0];
%     else
%         v1 = [0, 0, 1];
%     end
%     v2 = cross(normal, v1);
%     v1 = cross(normal, v2);
%     B = [v1(:), v2(:), normal(:)];
%     
%     for i = 1:size(vertices,1)
%         vertices(i,:) = (B\vertices(i,:)')';
%     end
%     
%     %Flatten vertices in the normal direction
%     vertices(:,3) = 0;
%     
%     %Extract contour (Jarvis march/gift wrapping)
%     wrappingPoints = NaN(size(vertices)); %Preallocate
%     [~,index] = min(vertices(:,1));
%     pointOnHull = vertices(index,:);
%     wrappingPoints(1,:) = pointOnHull;
%     i = 1;
%     endpoint = Inf;
%     while norm(endpoint - wrappingPoints(1,:)) > 0.0001    
%         wrappingPoints(i,:) = pointOnHull;
%         endpoint = vertices(1,:);
%         for j = 2:size(vertices,1)
%             if (norm(endpoint - pointOnHull) < 0.00001) || isLeft(wrappingPoints(i,:), endpoint, vertices(j,:)) %Potential rounding problems
%                 endpoint = vertices(j,:);
%             end
%         end
%         i = i + 1;
%         pointOnHull = endpoint;
%     end
%        
%     %Copy to output
%     vertices = wrappingPoints(~isnan(wrappingPoints(:,1)),:);
%     
%     %Change basis back
%     for i = 1:size(vertices,1)
%         vertices(i,:) = (B*vertices(i,:)')';
%     end
% end