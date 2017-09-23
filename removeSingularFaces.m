function faces = removeSingularFaces(faces)
    %Remove faces with duplicate corners
    allSingular = logical([]);
    for i = 1:size(faces,1)
        allSingular = [allSingular (numel(unique(faces(i,:))) < 3)];
    end
    if any(allSingular)
        faces(allSingular,:) = [];
    end
end