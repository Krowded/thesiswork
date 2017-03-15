%Adjust current vertices as much as possible
function [vertices, groups, numberOfMovedVertices] = adjustVertices(vertices, groups, newVertices, normal)
    numberOfMovedVertices = 0;
    
    for i = 1:min(length(newVertices), length(groups))
        %Remove normal component
        newPosition = newVertices(i,:);
        newPosition = newPosition - normal.*newVertices(i,:);
        
        %Find closest vertex
        currentMin = Inf;
        for j = 1:length(groups(:,1))
            vertex = vertices(groups(j,1),:); %Only checking one pair component, assuming grouping is good
            vertex = vertex - normal.*vertex; %Remove normal component
            distance = norm(newPosition - vertex);
            if distance < currentMin
                currentMin = distance;
                closestPair = j;
            end
        end
        
        %Move vertices to pair coordinates, with old vertex values in the
        %normal direction
        id1 = groups(closestPair,1);
        id2 = groups(closestPair,2);
        vertices(id1,:) = newPosition + normal.*vertices(id1,:);
        vertices(id2,:) = newPosition + normal.*vertices(id2,:);
        groups(closestPair,end) = 1;
        
        numberOfMovedVertices = numberOfMovedVertices + 1;
    end
end
