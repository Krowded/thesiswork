[vert, face] = read_ply('frontwall.ply');

%For the first test we're just reapplying every point
newverts = [%0, 70.0000, 64.9820;
            0, 72.1171, 87.4820;
            0, 32.1171, 87.4820;
            0, 72.1171, 52.4820;
            0, 32.1171, 52.4820];
targetInd =[51:54, 27:28, 30:31];
normal = [1,0,0];

%vert([51:54,27:28,30:31],:)
[vert, face] = expansion(vert,face,targetInd,newverts, normal);
%vert([51:54,27:28,30:31],:)
write_ply(vert, face, 'test2.ply', 'ascii');


function [pairs] = groupVertices(vertices, targetIndices, normal)
    %Pair up vertices in direction of normal
    %assuming even number of vertices, and assuming them as pairs
    pairs = zeros(length(targetIndices)/2,2);
    pairIndex = 1;
    while length(targetIndices) > 1
        %Remove distance in normal direction
        current = vertices(targetIndices(1),:);
        current = current - normal.*current;
        currentMin = Inf;
        
        for i = 2:length(targetIndices)
            vertex = vertices(targetIndices(i),:);
            vertex = vertex - normal.*vertex;
            distance = norm(current - vertex);
            if distance < currentMin
                currentMin = distance;
                match = i;
            end
        end
        
        %Move to pairs list
        pairs(pairIndex,1) = targetIndices(1);
        pairs(pairIndex,2) = targetIndices(match);        
        pairIndex = pairIndex + 1;
        
        %Remove from indices list
        %Delete match first so index stays the same
        targetIndices(match) = [];
        targetIndices(1) = [];
    end

end

function [vertices, faces] = expansion(vertices, faces, targetIndices, newVertices, normal)

    pairs = groupVertices(vertices, targetIndices, normal);
    
    %Adding a 0 to the end of each pair. If the pair has been done it is set
    %to a 1
    pairs(:, end+1) = 0;
    
    
    movedVertices = 0;
    
    %Adjust current ones as much as possible
    for i = 1:min(length(newVertices), length(pairs))
        %Remove normal component
        newPosition = newVertices(i,:);
        newPosition = newPosition - normal.*newVertices(i,:);
        
        %Find closest vertex
        currentMin = Inf;
        for j = 1:length(pairs(:,1))
            vertex = vertices(pairs(j,1),:); %Only checking one pair component, assuming grouping is good
            vertex = vertex - normal.*vertex; %Remove normal component
            distance = norm(newPosition - vertex);
            if distance < currentMin
                currentMin = distance;
                closestPair = j;
            end
        end
        
        %Move vertices to pair coordinates, with old vertex values in the
        %normal direction
        id1 = pairs(closestPair,1);
        id2 = pairs(closestPair,2);
        vertices(id1,:) = newPosition + normal.*vertices(id1,:);
        vertices(id2,:) = newPosition + normal.*vertices(id2,:);
        pairs(closestPair,end) = 1;
        
        movedVertices = movedVertices + 1;
    end

    %Add new one / remove ones left over
    leftToDo = length(newVertices) - movedVertices;
    
    if leftToDo > 0 %Add new ones
    else %Remove leftovers by moving them to nearest used up existing vertex
        %Leftovers are all pairs with a 0 in the third position
        leftovers = pairs(pairs(:,end) == 0,:);
        leftovers = leftovers(:,1:(end-1));
        %Should probably use face data for this
        for i = 1:length(leftovers(:,1))
            currentPair = leftovers(i,:);
            vertex = vertices(currentPair(1),:);
            
            %Find closest vertex from the front of each pair
            currentMin = Inf;
            finishedPairs = pairs(pairs(:,end) == 1, 1:2);
            for j = 1:length(finishedPairs(:,1))
                %Only checking one
                position = vertices(finishedPairs(j,1),:);
                distance = norm(position - vertex);
                if distance < currentMin
                    currentMin = distance;
                    closestPair = j;
                end
            end
            
            %Set the entire pair to be in the same position as it's closes
            %neighbour
            vertices(currentPair,:) = vertices(finishedPairs(closestPair,:), :);
        end
    end    
end