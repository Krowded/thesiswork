function [vertices, faces] = expansion(vertices, faces, targetIndices, newVertices, normal)

    groups = groupVertices(vertices, targetIndices, normal);
    
    %Adding a 0 to the end of each group. If the group has been used it is set to a 1
    groups(:, end+1) = 0;
    
    [vertices, groups, movedVertices] = adjustVertices(vertices, groups, newVertices, normal);

    %Add new one / remove ones left over
    leftToDo = length(newVertices) - movedVertices;
    
    if leftToDo > 0 %Add new ones
        vertices = addNewVertices(vertices, groups, newVertices, normal);
    else 
        vertices = removeUnusedVertices(vertices, groups);
    end    
end