%Returns a vector of all face (and their normals if provided) that
%references any of indices
function [faces, normals] = removeFacesWithoutIndices(faces, indices, optional_normals)
    if nargin < 3
        normals = zeros(size(faces,1));
    else
        normals = optional_normals;
    end

    %Remove faces without matching indices
    indices = unique(indices(:))';   
    indicesToKeep = any(faces(:,1) == indices, 2) | any(faces(:,2) == indices, 2)| any(faces(:,3) == indices, 2);
    faces = faces(indicesToKeep,:);
end