function [foundationStructs, corners] = buildAnySidedFoundation(numberOfWalls, radius, height, wallThickness)
    up = [0 1 0];
    front = [0 0 1];
    evenNumWalls = mod(numberOfWalls,2) == 0;
    angleBetweenWalls = 360/numberOfWalls;
    cornerAngle = angleBetweenWalls/2;    
    
    %Detail
    linesX = 20;
    linesY = 11;
    
    %Randomize wall section widths
    width = radius * tand(angleBetweenWalls/2);
    if evenNumWalls
        widths = rand(1, numberOfWalls/2);
        widths = widths*(2*width) + (width/2);
        [~,longestWallID] = max(widths);
        widths = [widths widths];
    else
        error('Only allowing even number of walls. For now.');
    end
    
    corners = [];
    foundationStructs = newWallStruct();
    lastRightCorner = [-widths(1); height; radius]; %Y value doesn't really matter, only used for saving slots
    for i = 1:numberOfWalls
        %Calculate corners of next wall
        rads = -((i-1)*angleBetweenWalls/180)*pi;
        R = rotationVectorToMatrix(rads*up);
        forward = (R*front')';
        rightCorner = R*[2*widths(i); 0; 0] + lastRightCorner;
        leftCorner = lastRightCorner;
        lastRightCorner = rightCorner;
        
        %Slots for roof
        if i == longestWallID || i == (longestWallID + numberOfWalls/2)
            corners(end+1,:) = rightCorner;
            corners(end+1,:) = leftCorner;
        end
        
        %Flatten
        leftCorner = leftCorner([1 3]);
        rightCorner = rightCorner([1 3]);
        
        %Create wall section
        foundationStructs(i) = createWallFromSpecifications(leftCorner, rightCorner, height, wallThickness, forward, up, linesX, linesY, cornerAngle, cornerAngle);
        foundationStructs(i) = retriangulateWall(foundationStructs(i), []);
    end
end