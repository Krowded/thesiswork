%Return indices of the normals that are (almost) perpendicular to the given normal
function [faceIndices] = getPerpendicularFaceIndices(faceNormals, normal, accuracy)
    if nargin < 3
        accuracy = 0.05;
    end

    faceIndices = [];
    for i = 1:size(faceNormals,1)
        %Check for slightly more than zero to collect highly angled faces
        if abs(dot(normal, faceNormals(i,:))) < accuracy
            faceIndices = [faceIndices, i];
        end
    end 
end