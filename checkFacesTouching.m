%Check if two faces are connected by at least one index
function [areTouching] = checkFacesTouching(face1, face2)
    connectionsBetweenFaces = intersect(face1,face2);
    areTouching = ~isempty(connectionsBetweenFaces);
end