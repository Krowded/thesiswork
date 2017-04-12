%Takes bunch of faces and indices and return them in the order they are
%connected, as well as the length of each of those chains
%Assumes each face is only part of one chain
function [faceIndexChains, chainLengths] = getChainsOfFaces(faces, indices)
    face1Index = indices(1);
    indices(1) = [];
    faceChains(1) = face1Index;
    currentChain = 1;
    chainLengths(currentChain) = 1;
    i = 1;
    while ~isempty(indices)        
        face2Index = indices(i);
        
        facesAreConnected = checkFacesConnected(faces(face1Index,:),faces(face2Index,:));
        if facesAreConnected
            %Add to list
            faceChains = [faceChains face2Index];
            chainLengths(currentChain) = chainLengths(currentChain) + 1;
            
            %Remove from search list
            indices(i) = [];
            
            %Set to face1 and check for connections in next step
            face1Index = face2Index;
            
            %Reset search index
            i = 1;
        elseif i == length(indices)
            %Should have finished a chain. Check if the loop closes and
            %discard it if it doesn't
            lastLength = chainLengths(currentChain) - 1;
            endIndex = length(faceChains);
            firstFaceInChain = faces(faceChains(endIndex-lastLength),:);
            lastFaceInChain = faces(faceChains(endIndex),:);
            facesAreTouching = checkFacesTouching(firstFaceInChain, lastFaceInChain);
            if ~facesAreTouching || chainLengths(currentChain) < 3 %Discard last chain 
                faceChains((endIndex-lastLength):end) = [];
            else %Move to the next one                
                currentChain = currentChain + 1;
            end
            
            %Reset for the next chain
            chainLengths(currentChain) = 1;
            face1Index = indices(1);
            indices(1) = [];
            faceChains = [ faceChains face1Index ];
            i = 1;
        else
            %No match. Look at next
            i = i + 1;
        end
    end
    
    %Remove trailing index
    if chainLengths(end) == 1
        chainLengths(end) = [];
        faceChains(end) = [];
    end
    
    faceIndexChains = faceChains;
end