%Returns the indices of the vertices of all faces with normals in the same
%direction as normal
function indices = getSameDirectionVertexIndices(faces, normals, normal)
    frontFaces = getSameDirectionFaceIndices(normals, normal);
    indices = unique(faces(frontFaces,:));    
end