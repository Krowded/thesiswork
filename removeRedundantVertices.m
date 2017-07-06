%Takes ordered vertices and removes any vertices directly on a line between
%two others
function vertices = removeRedundantVertices(vertices)
    i = 1;
    while i < (size(vertices,1) - 2)
        first = vertices(i,:);
        second = vertices(i+1,:);
        third = vertices(i+2,:);
        
        v1 = second-first;
        v1 = normalize(v1);
        
        v2 = third-first;
        v2 = normalize(v2);
        
        if abs(atan2(norm(cross([v1 0],[v2 0])),dot(v1,v2))) < 0.0001
            vertices(i+1,:) = [];
        else
            i = i + 1;    
        end
    end
end