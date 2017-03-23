%Remove leftover vertices by moving them to nearest vertex
function [vertices] = removeUnusedVertices(vertices, groups)
    %Leftovers are all pairs with a 0 in the third position
    leftovers = groups(groups(:,end) == 0,:);
    leftovers = leftovers(:,1:(end-1));
    %Should probably use face data for this
    for i = 1:length(leftovers(:,1))
        currentGroup = leftovers(i,:);
        vertex = vertices(currentGroup(1),:);

        %Find closest vertex from the front of each pair
        currentMin = Inf;
        finishedGroups = groups(groups(:,end) == 1, 1:2);
        for j = 1:length(finishedGroups(:,1))
            %Only checking one
            position = vertices(finishedGroups(j,1),:);
            distance = norm(position - vertex);
            if distance < currentMin
                currentMin = distance;
                closestGroup = j;
            end
        end

        %Set the entire group to be in the same position as it's closest
        %neighbour
        vertices(currentGroup,:) = vertices(finishedGroups(closestGroup,:), :);
    end
end