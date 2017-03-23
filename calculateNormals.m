function [normals] = calculateNormals(vertices, faces)
    normals = zeros(size(faces));

    for i = 1:size(faces,1)
        triangle = faces(i,:);
        v1 = vertices(triangle(2),:) - vertices(triangle(1),:);
        v2 = vertices(triangle(3),:) - vertices(triangle(1),:);
        normals(i,:) = normalize(cross(v1,v2));
    end
end