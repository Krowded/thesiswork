function betterpcshow(vertices)
    if size(vertices,2) == 2
        vertices = [vertices, zeros(size(vertices,1),1)];
    end

    markersize = max([500-size(vertices,1), 1]);
    pcshow(vertices, 'MarkerSize', markersize);
end