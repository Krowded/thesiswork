%Assumes closed loops, assumes holes with depth
function [holeIndices, lengthsOfLoops] = findHoles(vertices, faces, normal, indices, optional_normals)
    %Take care of optionals (look below for normals)
    if nargin < 4
        indices = 1:size(vertices,1);
    end
    
    %Calculate normals if not provided
    %(Faster if done after face removal, but harder to read)
    if nargin < 5 
        normals = calculateNormals(vertices, faces);
    else
        normals = optional_normals;
    end

    
    %Remove unwanted faces
    [faces, normals] = removeFacesWithoutIndices(faces, indices, normals);
        
    %Find faces that are (almost) perpendicular to the normal
    sideFaceIndices = getPerpendicularFaceIndices(normals, normal);
    sideVertexIndices = unique(faces(sideFaceIndices,:));
    
    %Get front and back faces
    frontFaceIndices = getSameDirectionFaceIndices(normals, normal);
    frontVertexIndices = unique(faces(frontFaceIndices,:));
    backFaceIndices = getSameDirectionFaceIndices(normals, -normal);
    backVertexIndices = unique(faces(backFaceIndices,:));
    
    %Get boundary between front/back and side faces
    boundaryVertexIndices = unique( [ intersect(sideVertexIndices, frontVertexIndices); intersect(sideVertexIndices, backVertexIndices) ]);
    [~,temp] = ismember(faces(sideFaceIndices,:), boundaryVertexIndices);
    boundaryFaceIndices = sideFaceIndices(any(temp,2));
   
    %Check which of those face are connected to each other
    [faceChains, chainLengths] = getChainsOfFaces(faces, boundaryFaceIndices);
    
    %Get contours from the vertices in the connected faces
    startingIndex = 1;
    holeIndices = [];
    lengthsOfLoops = [];
    for i = 1:length(chainLengths)
        if chainLengths(i) < 4 %Precaution. Probably unnecessary now
            startingIndex = startingIndex + chainLengths(i);
            continue;
        end
        
        chainVertexIndices = unique(faces(faceChains(startingIndex:(startingIndex+chainLengths(i)-1)),:));
        
        %Check which vertices are shared with front and back to get the holes on each side
        frontHoleIndices = intersect(chainVertexIndices, frontVertexIndices);
        backHoleIndices = intersect(chainVertexIndices, backVertexIndices);
        
        %Get contour in winding order
        [~,frontHoleIndices] = extractSimplifiedContour3D(vertices, normal, frontHoleIndices);
        [~,backHoleIndices] = extractSimplifiedContour3D(vertices, normal, backHoleIndices); %Same normal because they need to be wound the same way
        
        %Sanity check (could happen with weird geometry, fix later)
        if length(frontHoleIndices) ~= length(backHoleIndices)
            error('Non matching holes')
        end
        
        %Append to output
        holeIndices = [holeIndices; frontHoleIndices; backHoleIndices];
        lengthsOfLoops = [lengthsOfLoops length(frontHoleIndices)];
        
        startingIndex = startingIndex + chainLengths(i);
    end
end