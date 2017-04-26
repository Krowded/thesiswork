%Returns a vector of all faces (and their normals if provided) that
%reference only vertices in the indices array
function modelStruct = removeFacesWithOnlyIndices(modelStruct, indices)
    i = 1;
    while i < size(modelStruct.faces,1)
        if length(intersect(modelStruct.faces(i,:), indices)) == 3
            modelStruct.faces(i,:) = [];
            %modelStruct.normals(i,:) = [];
            continue;
        end
        i = i+1;
    end
end