%Return indices of the normals that are (almost) parallel to the given normal
function [faceIndices] = getSameDirectionFaceIndices(faceNormals, normal, accuracy)
    if nargin < 3
        accuracy = 0.999;
    end

    faceIndices = [];
    for i = 1:size(faceNormals,1)
        %Check for slightly more than zero to keep slightly angled faces
        if dot(normal, faceNormals(i,:)) > accuracy
            faceIndices = [faceIndices, i];
        end
    end 
end