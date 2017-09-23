function model = calculateVertexNormals(model)
    model.vertexNormals = model.vertices;
    for i = 1:size(model.vertices,1)
        connectedFaceNormals = model.faceNormals(any(model.faces == i,2),:);
        normalize(mean(connectedFaceNormals, 1))
        model.vertexNormals(i,:) = normalize(mean(connectedFaceNormals, 1));
    end
end