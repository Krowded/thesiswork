%Get indices of all faces containing any vertexIndices
function facesContaining = getFacesContaining(faces, vertexIndices)
    facesContaining = [];
    for k = 1:size(faces,1)
        if ~isempty(intersect(faces(k,:), vertexIndices))
            facesContaining(end+1) = k;
        end
    end
end