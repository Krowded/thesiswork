%Create faces between each wall segment and combines it all in a single
%structure
function foundationStruct = fuseWalls(foundationStructs)
    verticesPerStripFront = length(foundationStructs(1).frontCornerIndicesLeft); %SHORT SIGHTED, CHANGE!
    verticesPerStripBack = length(foundationStructs(1).backCornerIndicesLeft); %SHORT SIGHTED, CHANGE!
    numberOfFacesPerPairFront = 2*verticesPerStripFront - 2;
    numberOfFacesPerPairBack = 2*verticesPerStripBack - 2;
    numberOfFacesPerPairOfWalls = numberOfFacesPerPairFront + numberOfFacesPerPairBack;
    numberOfWalls = length(foundationStructs);
    numberOfFacesFront = numberOfFacesPerPairFront * numberOfWalls;
    numberOfFacesBack = numberOfFacesPerPairBack * numberOfWalls;
    numberOfFaces = numberOfFacesFront + numberOfFacesBack;
    newFaces = zeros(numberOfFaces,3);
    totalSize = 0;
    
    %Add section between each wall
    for i = 1:(numberOfWalls-1)
        %Get strips
        stripRightFront = foundationStructs(i).gridIndicesFront(:,1) + totalSize;
        stripLeftBack = foundationStructs(i).gridIndicesBack(:,1) + totalSize;
        totalSize = totalSize + size(foundationStructs(i).vertices,1);
        stripLeftFront = foundationStructs(i+1).gridIndicesFront(:,end) + totalSize;
        stripRightBack = foundationStructs(i+1).gridIndicesBack(:,end) + totalSize;
        
        %Fuse strips
        frontFacesStartingIndex = (i-1)*numberOfFacesPerPairOfWalls + 1;
        backFacesStartingIndex = frontFacesStartingIndex + numberOfFacesPerPairFront;
        newFaces(frontFacesStartingIndex:(frontFacesStartingIndex + numberOfFacesPerPairFront - 1),:) = fuseTwoStripsLocal(stripLeftFront, stripRightFront);
        newFaces(backFacesStartingIndex:(backFacesStartingIndex + numberOfFacesPerPairBack - 1),:) = fuseTwoStripsLocal(stripLeftBack, stripRightBack);
    end
    
    %Final two walls
    stripRightFront = foundationStructs(end).gridIndicesFront(:,1) + totalSize;
    stripLeftBack = foundationStructs(end).gridIndicesBack(:,1) + totalSize;
    stripLeftFront = foundationStructs(1).gridIndicesFront(:,end);
    stripRightBack = foundationStructs(1).gridIndicesBack(:,end);
    
    frontFacesStartingIndex = (numberOfWalls-1)*numberOfFacesPerPairOfWalls + 1;
    backFacesStartingIndex = frontFacesStartingIndex + numberOfFacesPerPairFront;
    newFaces(frontFacesStartingIndex:(frontFacesStartingIndex + numberOfFacesPerPairFront - 1),:) = fuseTwoStripsLocal(stripLeftFront, stripRightFront);
    newFaces(backFacesStartingIndex:end,:) = fuseTwoStripsLocal(stripLeftBack, stripRightBack);    

    %Collect all foundation structs in a single struct
    foundationStruct = mergeModels(foundationStructs);
    
    %Append new faces
    foundationStruct.faces = [foundationStruct.faces; newFaces];
    
    function [newFaces] = fuseTwoStripsLocal(stripLeft, stripRight)
        leftSize = size(stripLeft,1);
        rightSize = size(stripRight,1);
        minStripSize = min(leftSize, rightSize);
        maxStripSize = max(leftSize, rightSize);
        
        %Normally connect the strips
        newFaces = zeros(2*(maxStripSize-1), 3);
        for j = 1:(minStripSize-1)
            newFaces((2*j)-1,:) = [stripLeft(j), stripLeft(j+1),  stripRight(j)];
            newFaces((2*j),:) = [stripLeft(j+1), stripRight(j+1), stripRight(j)];
        end
        
        
        %THIS MIGHT WORK, BUT IT'S UNTESTED
%         %Connect the remaining indices to the last vertex of the other
%         if leftSize == rightSize
%             return;
%         end
%         
%         if leftSize < rightSize
%             lastIndex = stripLeft(end);
%             stripLeft = zeros(maxStripSize-minStripSize,1);
%             stripLeft(:) = lastIndex;
%         else
%             lastIndex = stripRight(end);
%             stripRight = zeros(maxStripSize-minStripSize,1);
%             stripRight(:) = lastIndex;
%         end
%         
%         newFaces((2*minStripSize):end) = fuseTwoStripsLocal(stripLeft, stripRight);
    end
end