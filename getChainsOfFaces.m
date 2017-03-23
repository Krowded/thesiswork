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
            %Finished a chain. Reset.
            face1Index = indices(1);
            indices(1) = [];
            currentChain = currentChain + 1;
            chainLengths(currentChain) = 1;
            faceChains = [ faceChains face1Index ];
            i = 1;
        else
            %No match. Look at next
            i = i + 1;
        end
    end
    
    faceIndexChains = faceChains;
end