function corners = boundingBoxCornerVertices(vertices, normal, up)
    xvec = normal;
    x = vertices*xvec';
    maxX = max(x);
    minX = min(x);
    
    yvec = up;
    y = vertices*yvec';
    maxY = max(y);
    minY = min(y);
    
    zvec = normalize(fastCross(xvec,yvec));
    z = vertices*zvec';
    maxZ = max(z);
    minZ = min(z);
    
    %Get a set of slots from front and back slices
    corners = [maxX*xvec + maxY*yvec + maxZ*zvec;
               maxX*xvec + maxY*yvec + minZ*zvec;
               maxX*xvec + minY*yvec + minZ*zvec;
               maxX*xvec + minY*yvec + maxZ*zvec;
               minX*xvec + maxY*yvec + maxZ*zvec;
               minX*xvec + maxY*yvec + minZ*zvec;
               minX*xvec + minY*yvec + minZ*zvec;
               minX*xvec + minY*yvec + maxZ*zvec];
end