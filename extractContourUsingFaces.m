% Takes vertices, connections (faces), and a normal and returns the vertices
% of the 2D convex hull with a normal equal to the normal argument in order. 
% The hull is calculated so that each vertex is connected by at least a face
% to the others
function [vertices] = extractContourUsingFaces(vertices, connections, normal)
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
    vertices(:,3) = [];

    
    [startingHeight,index] = min(vertices(:,2)); %Lowest point
    wrappingIndices(1) = index;
    nextDirection = [-1; 0]; %Start going left
    
    currentConnections = unique(connections(any(connections == wrappingIndices(end),2),:));
    currentConnections(currentConnections == index) = [];
    [~,I] = max(vertices(currentConnections,:)*nextDirection);
    wrappingIndices(end+1) = currentConnections(I);
    nextDirection = (vertices(wrappingIndices(end),:) - vertices(wrappingIndices(end-1),:))';
    
    counter = 0;
    while abs(vertices(wrappingIndices(end),2) - startingHeight) > 0.1
        currentConnections = unique(connections(any(connections == wrappingIndices(end),2),:));
        currentConnections(currentConnections == wrappingIndices(end)) = [];
        [~,I] = max(vertices(currentConnections,:)*nextDirection);

        wrappingIndices(end+1) = currentConnections(I);
        nextDirection = normalize(normalize((vertices(wrappingIndices(end),:) - vertices(wrappingIndices(end-1),:)))' + nextDirection);
        
        if counter == 100
            betterpcshow(vertices(wrappingIndices,:))
        end
        counter = counter + 1;
    end
    
        
    %Copy to output
    wrappingIndices = wrappingIndices(~isnan(wrappingIndices));
    vertices = vertices(wrappingIndices,:);
    vertices = [vertices, zeros(size(vertices,1),1)];
    
    %Change basis back
    for i = 1:size(vertices,1)
        vertices(i,:) = (B*vertices(i,:)')';
    end
end