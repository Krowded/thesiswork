%Returns the four corner vertices of a rectangle that is a convex hull
%of contourVertices. If up is not provided, y is assumed to be the up
%vector.
%Also assumes that all values in the normal direction are identical
function slotVertices = slotsFromContour(contourVertices, front, up)
    z = front;
    y = up;
    x = normalize(cross(y, z));
    
    xvalues = contourVertices*x';
    yvalues = contourVertices*y';
    maxx = max(xvalues);
    minx = min(xvalues);
    maxy = max(yvalues);
    miny = min(yvalues);
    
    slotVertices = zeros(4,3);
    slotVertices(1,:) = minx*x + maxy*y;
    slotVertices(2,:) = maxx*x + maxy*y;
    slotVertices(3,:) = maxx*x + miny*y;
    slotVertices(4,:) = minx*x + miny*y;
    
    %Restore depth
    slotVertices = slotVertices - z.*slotVertices + z.*dot(z,contourVertices(1,:));
end