%Check if two faces are connected by exactly two indices
function [areConnected] = checkFacesConnected(face1, face2)
    connectionsBetweenFaces = intersect(face1,face2);
    areConnected = length(connectionsBetweenFaces) == 2;
end