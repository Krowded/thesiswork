%Removes all facs between midPoint and the edges surrounding it
function [vertices, faces] = removeMiddleOut(vertices, faces, midPointIndices, edgeIndices, numberOfLevels, optional_normal)
    if nargin < 6
        temp1 = vertices(faces(1,2),:) - vertices(faces(1,1),:);
        temp2 = vertices(faces(1,3),:) - vertices(faces(1,1),:);
        optional_normal = normalize(cross(temp1,temp2));
    end

    B = getBaseTransformationMatrix(optional_normal);
    
    midIndices = midPointIndices;
    checkFaces = getFacesContaining(faces,midIndices);
    facesToRemove = [];
    
    i = 1;
    while i < length(checkFaces)
        face = faces(checkFaces(i),:);
        edgeMatches = intersect(face, edgeIndices);
        if isempty(edgeMatches) %If not at the edge, delete this face and propagate outwards
            newMidVertices = face(face ~= midPointIndices);
            checkFaces = [ checkFaces, getFacesContaining(faces,  newMidVertices) ];
            midIndices(end+1) = newMidVertices; 
        elseif length(edgeMatches) == 1
            otherTwo = face(face ~= edgeMatches);
            centerPoint = intersect(otherTwo, midIndices);
            outsidePoint = otherTwo(otherTwo ~= centerPoint);
            
            if isLeft(B\vertices(centerPoint,:)', B\vertices(outsidePoint,:)', B\vertices(edgeMatches(1),:)')
                %Left
                faces(checkFaces(i),face == centerPoint) = edgeMatches(1)-numberOfLevels;
            else
                %Right
                faces(checkFaces(i),face == centerPoint) = edgeMatches(1)+numberOfLevels;
            end           
        else
            facesToRemove(end+1) = checkFaces(i);
        end
        
        i = i+1;
    end
    
    faces(facesToRemove,:) = [];
    vertices = removeUnreferencedVertices(vertices, faces);
end