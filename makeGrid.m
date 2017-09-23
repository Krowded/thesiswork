%Creates a grid of vertices (left and right corners given as 2D vectors)
function [vertices, lineDistanceSide, lineDistanceUp] = makeGrid(left, right, minY, maxY, linesX, linesY)
    %Prep
    minX = left(1);
    maxX = right(1);
    leftZ = left(2);
    rightZ = right(2);

    densityX = linesX - 1;
    densityY = linesY - 1;
    distanceBetweenLinesX = (maxX - minX)/densityX;
    distanceBetweenLinesY = (maxY - minY)/densityY;
    distanceBetweenLinesZ = (rightZ - leftZ)/densityX;

    %Grid creation
    vertices = zeros(linesX*linesY, 3);
    vertices(:,3) = rightZ;

    for i = 1:linesX
        vertices(i:linesX:size(vertices,1), 1) = minX + (i-1)*distanceBetweenLinesX;
        vertices(i:linesX:size(vertices,1), 3) = leftZ + (i-1)*distanceBetweenLinesZ;
    end

    for i = 1:linesY
        vertices(((i-1)*linesX+1):(i*linesX), 2) = minY + (linesY-i)*distanceBetweenLinesY;
    end

    lineDistanceUp = distanceBetweenLinesY;
    lineDistanceSide = distanceBetweenLinesX + distanceBetweenLinesZ;
end