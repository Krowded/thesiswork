%Returns a vector of all face (and their normals if provided) that
%references any of indices
function [faces, normals] = removeFacesWithoutIndices(faces, indices, optional_normals)
    if nargin < 3
        normals = zeros(size(faces,1));
    else
        normals = optional_normals;
    end

    %Remove faces without matching indices
    i = 1;
    while i < size(faces,1)
        if isempty(intersect(faces(i,:), indices))
            faces(i,:) = [];
            normals(i,:) = [];
            continue;
        end
        i = i+1;
    end
end