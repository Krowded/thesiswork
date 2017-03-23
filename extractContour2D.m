%Takes 2D vertices and optionally indices, and returns the vertices
%of the 2D convex hull and their original indices
function [vertices,indices] = extractContour2D(vertices, optional_indices)
    if nargin < 2
        optional_indices = 1:size(vertices,1);
    else
        vertices = vertices(optional_indices,:);
    end
    
    %Extract contour with Jarvis march/gift wrapping (with extra step of
    %using indices)
    wrappingIndices = NaN(1,size(vertices,1));
    [~,index] = min(vertices(:,1)); %Leftmost point
    pointOnHullIndex = index;
    wrappingIndices(1) = pointOnHullIndex;
    
    endpointIndex = wrappingIndices(1) - 1;
    if endpointIndex == 0 %Since there's no do-while loop this is what we do
        endpointIndex = wrappingIndices(1)+1;
    end
        
    i = 1;
    numberOfVertices = size(vertices,1);
    while endpointIndex ~= wrappingIndices(1) && (i+1) < numberOfVertices
        wrappingIndices(i) = pointOnHullIndex;
        endpointIndex = 1;
        for j = 2:numberOfVertices            
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
    indices = optional_indices(wrappingIndices);
    vertices = vertices(wrappingIndices,:);
    
    %Remove duplicate points
    tempIndices = 1:size(vertices,1);
    [vertices, ~, tempIndices] = remove2DDuplicatePoints(vertices, tempIndices);
    indices = indices(tempIndices);
end
