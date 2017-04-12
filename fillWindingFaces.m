%Create faces between the depth levels by creating faces between the
%new vertices in winding order
%Assumes equal number of levels for every vertex, and vertices arranged in 
%winding order per level like so:
%[ vertex1level1, vertex2level1, vertex3level1,..... vertex1level2, vertex2level2, vertex3level2, ... ]
function [faces] = fillWindingFaces(numberOfVerticesPerLevel, numberOfLevels, indices)
    faces = zeros(2*(numberOfLevels-1)*numberOfVerticesPerLevel,3); %Preallocate two faces for every  vertex and level-1
    startingIndex = 1;
    lastIndex = startingIndex + (numberOfVerticesPerLevel-1);
    
    %One level of faces between every two levels of vertices
    for i = 0:(numberOfLevels-2)
        thisLevel = i * numberOfVerticesPerLevel;
        nextLevel = (i+1)*numberOfVerticesPerLevel;
        
        %Add faces between this level and the next
        for j = 0:(numberOfVerticesPerLevel-2) %Final vertex is dealt with separately
            thisIndex = startingIndex + j;
            nextIndex = startingIndex +(j+1);

            faceIndex = 1 + 2*j + numberOfLevels*i;
            faces(faceIndex:(faceIndex+1),:) = createFacesBetween(thisIndex, nextIndex, thisLevel, nextLevel);
        end
        
        %Make faces between last and first vertices to close the loop
        faceIndex = size(faces,1) - (numberOfLevels-1)*2 + 1 + 2*i;
        faces(faceIndex:(faceIndex+1),:) = createFacesBetween(lastIndex, startingIndex, thisLevel, nextLevel);
    end
    
    function faces = createFacesBetween(thisIndex, nextIndex, thisLevel, nextLevel)
        index1 = indices(thisIndex + thisLevel);
        index2 = indices(thisIndex + nextLevel);
        index3 = indices(nextIndex + thisLevel);
        index4 = indices(nextIndex + nextLevel);
        face1 = [ index1, index4, index2 ];
        face2 = [ index1, index3, index4 ];
        faces = [ face1; face2 ];
    end
end