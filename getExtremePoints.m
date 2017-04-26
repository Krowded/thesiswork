%Compares distance between points in the xdirection and out of those close
%to each other it returns the bigger one in the ydirection
function extremePoints = getExtremePoints(points, xdirection, ydirection)
    x = points*xdirection';
    [sortedX, sortedIndices] = sort(x);
    y = points*ydirection';

    extremePoints = [];
    closeVertices = [];
    i = 1;
    while i < size(sortedX,1)
        closeVertices = y(sortedIndices(i));
        for j = (i+1):size(sortedX,1)
            if abs(x(i) - x(j)) < 0.01
                closeVertices(end+1) = y(sortedIndices(j));
            else %Since it's sorted, it isn't close no later ones will be
                continue;
            end
        end
        extremePoints(end+1,:) = [x(i), max(closeVertices)];
        i = i + length(closeVertices);
    end    
end