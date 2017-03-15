%Groups vertices in lines in the normal direction
function [pairs] = groupVertices(vertices, targetIndices, normal)
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