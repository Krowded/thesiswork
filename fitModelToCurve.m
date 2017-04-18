function vertices = fitModelToCurve(vertices, curve, xdirection, ydirection)
    for i = 1:size(vertices,1)
        x = vertices(i,:)*xdirection';
        y = curve(x);
        
        vertices(i,:) = vertices(i,:) - ydirection*dot(vertices(i,:),ydirection) + y*ydirection;
    end
end