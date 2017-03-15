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

door = read_ply('door.ply');
doorcon = extractContour(door, normal);

function [vertices, faces] = expansion(vertices, faces, targetIndices, newVertices, normal)
    newVertices;
    newVertices = extractContour(newVertices,normal)
    vertices(targetIndices,:)
    targetIndices
    [otherVertices, otherIndices] = extractContour(vertices, normal, targetIndices)
    
    pairs = groupVertices(vertices, targetIndices, normal);
    
    %Adding a 0 to the end of each pair. If the pair has been used it is set to a 1
    pairs(:, end+1) = 0;
    
    [vertices, pairs, movedVertices] = adjustVertices(vertices, pairs, newVertices, normal);

    %Add new one / remove ones left over
    leftToDo = length(newVertices) - movedVertices;
    
    if leftToDo > 0 %Add new ones
        vertices = addNewVertices(vertices, pairs, newVertices, normal);
    else 
        vertices = removeUnusedVertices(vertices, pairs);
    end    
end