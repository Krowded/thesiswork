function betterpcshow(vertices)
    markersize = max([500-size(vertices,1), 1]);
    pcshow(vertices, 'MarkerSize', markersize);
end