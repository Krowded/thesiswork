%Create faces between the depth levels by creating faces between the
%new vertices in winding order
%Assumes equal number of levels for every vertex, and vertices arranged in 
%winding order per level like so:
%[ vertex1level1, vertex2level1, vertex3level1,..... vertex1level2, vertex2level2, vertex3level2, ... ]
function [faces] = fillWindingFaces(numberOfVerticesPerLevel, numberOfLevels, indices)
    faces = zeros(2*(numberOfLevels-1)*numberOfVerticesPerLevel,3); %Preallocate two faces for every  vertex and level-1
    startingIndex = 1;
    for i = 0:(numberOfLevels-2)
        for j = 0:(numberOfVerticesPerLevel-2) %Final vertex is dealt with separately
            thisIndex = indices(startingIndex + j);
            nextIndex = indices(startingIndex +(j+1));
            faceIndex = 1 + 2*j + numberOfLevels*i;
            thisLevel = i * numberOfVerticesPerLevel;
            nextLevel = (i+1)*numberOfVerticesPerLevel;
            faces(faceIndex,:) =    [ thisIndex+nextLevel,... 
                                      nextIndex+nextLevel,...
                                      thisIndex+thisLevel];
            faces(faceIndex+1,:) =  [ nextIndex+nextLevel,...
                                      nextIndex+thisLevel,... 
                                      thisIndex+thisLevel];
        end
    end
    %Make faces between last and first vertices to close the loop
    firstIndex = indices(startingIndex);
    lastIndex = indices(startingIndex + (numberOfVerticesPerLevel-1));
    faceIndex = size(faces,1) - (numberOfLevels-1)*2 + 1 ;
    for i = 0:(numberOfLevels-2)
        thisLevel = i * numberOfVerticesPerLevel;
        nextLevel = (i+1)*numberOfVerticesPerLevel;
        faces(faceIndex + 2*i,:) =      [ lastIndex + nextLevel,...
                                          firstIndex + nextLevel,...
                                          lastIndex + thisLevel];
        faces(faceIndex + 2*i + 1,:) =  [ firstIndex + nextLevel,...
                                          firstIndex + thisLevel,...
                                          lastIndex + thisLevel];
    end
end