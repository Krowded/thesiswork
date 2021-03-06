%Creates a random number of points (at least 3) within [(0,0) (10,10)], 
%takes the convex hull of the points and using vectors 
%between the points in winding order builds returns a matching foundation
function [foundationStructs, connections] = randomFoundation()
    connections = [];
    
    %Up always up
    up = [0 1 0];

    numFloors = 1;%randi(3);
    
    numPoints = randi([3 15]);
    points = 10*rand(numPoints,2);
    vertices = extractContour2D(points);
    startVertices = vertices(1:end-1,:);
    endVertices = vertices(2:end,:);
    betterpcshow(startVertices)
    foundationVectors = endVertices - startVertices;
%     foundationVectors = flipud(foundationVectors);
    
    %Get normalized vectors for angle calculations
    normalizedVectors = foundationVectors;
    forwardVectors = zeros(size(foundationVectors,1),3);
    for i = 1:size(foundationVectors,1)
        normalizedVectors(i,:) = normalize(foundationVectors(i,:));
        forwardVectors(i,:) = fastCross(up, [normalizedVectors(i,1), 0, normalizedVectors(i,2)]);
    end
    
    %Detail
    linesX = 20;
    linesY = 11;
    floorHeight = 5;
    wallThickness = 0.1;
    
    %Build the wall
    numberOfWalls = size(foundationVectors,1);
    foundationStructs = newWallStruct();
    for j = 1:numFloors
        height = floorHeight*j;
        for i = 1:numberOfWalls
            if (i-1 < 1); left = numberOfWalls; else; left = i-1; end
            angleLeft = (180 - acosd(dot(normalizedVectors(i,:), -normalizedVectors(left,:))))/2;
            
            if (i+1 > numberOfWalls); right = 1; else; right = i+1; end
            angleRight = (180 - acosd(dot(-normalizedVectors(i,:), normalizedVectors(right,:))))/2;

            index = (j-1)*numberOfWalls + i;
            foundationStructs(index) = createWallFromSpecifications(startVertices(i,:), endVertices(i,:), height, wallThickness, forwardVectors(i,:), up, linesX, linesY, angleLeft, angleRight);
            foundationStructs(index) = retriangulateWall(foundationStructs(index));
        end
    end
    
    
    % Add roof positioning slots
    maxX = max(points(:,1));
    minX = min(points(:,1));
    maxZ = max(points(:,2));
    minZ = min(points(:,2));
    foundationStructs(1).slots = [minX, height, maxZ;
                                  minX, height, minZ;
                                  maxX, height, minZ;
                                  maxX, height, maxZ];
end