%Returns a vector of all faces that
%reference only vertices in the indices array
function faces = removeFacesWithOnlyIndices(faces, indices)
    i = 1;
    while i < size(faces,1)
        if length(intersect(faces(i,:), indices)) == 3
            faces(i,:) = [];
            continue;
        end
        i = i+1;
    end
end