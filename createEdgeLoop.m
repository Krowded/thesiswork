function [edges] = createEdgeLoop(indices)
    edges = zeros(length(indices),2);
    for i = 1:(length(indices)-1)
        edges(i,:) = [indices(i), indices(i+1)];
    end
    edges(end,:) = [indices(end), indices(1)]; %Finish loop
end