function vertices = curveVertices(vertices, curveFunction, xdirection, ydirection)
    xvalues = vertices*xdirection';
    minPoint = min(xvalues);
    maxPoint = max(xvalues);
    
    %curveFunction exists between 0 and 100, so need to scale to that
    scale = 100/(maxPoint - minPoint);
    for i = 1:size(vertices,1)
        x = (xvalues(i) - minPoint)*scale;
        y = curveFunction(x)/scale;
        vertices(i,:) = vertices(i,:) + y*ydirection;
    end
end