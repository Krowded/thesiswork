function faces = removeFacesWithoutIndices(faces, indices)
    %Remove faces without matching indices
    i = 1;
    while i < size(faces,1)
        if isempty(intersect(faces(i,:), indices))
            faces(i,:) = [];
            continue;
        end
        i = i+1;
    end
end