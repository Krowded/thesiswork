function betterpcshow(vertices, markersize)
    if nargin < 2
        markersize = max([500-size(vertices,1), 1]);
    end

    if size(vertices,2) == 2
        vertices = [vertices, zeros(size(vertices,1),1)];
    end

    pcshow(vertices, 'MarkerSize', markersize);
end