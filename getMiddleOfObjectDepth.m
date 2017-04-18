function depth = getMiddleOfObjectDepth(vertices, normal)
    vertices = vertices*normal';
    maxDepth = max(vertices);
    minDepth = min(vertices);   
    depth = (maxDepth + minDepth)*0.5;
end