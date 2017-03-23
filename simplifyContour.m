%Removes redundant vertices on the same line as two other vertices
%Returns the remaining vertices and their original indices
%Assumes indices follow the order of the contour
function [vertices, indices] = simplifyContour(vertices, optional_indices, optional_accuracy)
    if nargin < 2
        indices = 1:size(vertices,1);
    else
        indices = optional_indices;
    end
    if nargin <3
        optional_accuracy = 0.9999;
    end

    keepGoing = 1;
    indicesOfRemovableIndices = [];
    while keepGoing == 1
        keepGoing = 0;
        for i = 1:((length(indices)-2)/2) %Doesn't touch the end of the loop atm
            ind1 = indices(2*i+1);
            ind2 = indices(2*i+2);
            ind3 = indices(2*i);
            vec1 = normalize(vertices(ind2,:) - vertices(ind1,:));
            vec2 = normalize(vertices(ind3,:) - vertices(ind1,:));

            %If vectors are parallel the midpoint is redundant
            if abs(dot(vec1, vec2)) > optional_accuracy
                keepGoing = 1;
                indicesOfRemovableIndices = [indicesOfRemovableIndices 2*i+1];
            end
        end
        indices(indicesOfRemovableIndices) = [];
        indicesOfRemovableIndices = [];
    end
    
    vertices = vertices(indices,:);
end