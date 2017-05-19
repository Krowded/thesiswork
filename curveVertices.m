function [vertices, maxMove] = curveVertices(vertices, curveFunction, xdirection, ydirection, minPoint, maxPoint)
    xvalues = vertices*xdirection';

    if nargin < 5
        minPoint = min(xvalues);
        maxPoint = max(xvalues);
    end

    %curveFunction exists between 0 and 100, so need to scale to that
    scale = 100/(maxPoint - minPoint);
    invscale = 1/scale;   
    
    %Apply curve function to each vertex
    x = (xvalues - minPoint)*scale;
    y = invscale*arrayfun(curveFunction, x);
    [~,i] = max(abs(y));
    maxMove = y(i);
    vertices = vertices + y*ydirection;
end