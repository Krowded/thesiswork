%Assumes closed loops, assumes holes with depth
function [holeIndices, lengthsOfLoops] = findHoles(vertices, faces, normal, indices, normals)
    %Take care of optionals (look below for normals)
    if nargin < 4
        indices = 1:size(vertices,1);
    end

    %Remove unwanted faces
    faces = removeFacesWithoutIndices(faces, indices);
    
    %Calculate normals if not provided
    if nargin < 5
        normals = calculateNormals(vertices, faces);
    end

    %Find faces that are (almost) perpendicular to the normal
    faceIndicesToCheck = getPerpendicularFaceIndices(normals, normal, 0.05);
    
    %Check which of those face are connected to each other
    [faceChains, chainLengths] = getChainsOfFaces(faces, faceIndicesToCheck);
    
    %Get contours from the vertices in the connected faces
    startingIndex = 1;
    holeIndices = [];
    lengthsOfLoops = [];
    for i = 1:length(chainLengths)
        if chainLengths(i) < 3
            startingIndex = startingIndex + chainLengths(i);
            continue;
        end
        
        chain = unique(faces(faceChains(startingIndex:(startingIndex+chainLengths(i)-1)),:));
        
        [~,indices] = extractSimplifiedContour3D(vertices, normal, chain);
        holeIndices = [holeIndices; indices];
        lengthsOfLoops = [lengthsOfLoops length(indices)];
        
         startingIndex = startingIndex + chainLengths(i);
    end    
end