function [areConnected] = checkFacesConnected(face1, face2)
    connectionsBetweenFaces = intersect(face1,face2);
    areConnected = length(connectionsBetweenFaces) == 2;
end