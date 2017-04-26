%Returns the 8 corner vertices of a rectangles that make up convex hulls
%of the front and back ends of the vertices matrix.
%If up is not provided, y is assumed to be the up vector.
function slotVertices = slotsFromModelVertices(vertices, normal, up)
    %Get extremes of depth
    depthValues = vertices*normal';
    front = min(depthValues);
    back = max(depthValues);
    
    %Get one slice from withing on tenth of the front, and one from within
    %one tenth of the back vertex
    tenthFromBack = front + (back-front)*0.9;
    tenthFromFront = front + (back-front) * 0.1;
    backVertices = vertices(depthValues > tenthFromBack, :);
    frontVertices = vertices(depthValues < tenthFromFront, :);
    
    %Could extract contour here, but faster without it
    
    %Get a set of slots from front and back slices
    slotVertices = zeros(8,3);
    slotVertices(1:4,:) = slotsFromContour(backVertices, normal, up);
    slotVertices(5:8,:) = slotsFromContour(frontVertices, normal, up);
end