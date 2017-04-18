%Returns the top 4 corners of the foundation model
function slotVertices = slotsFromFoundation(vertices, normal, optional_up)
    if nargin < 3
       optional_up = [0, 1, 0];
    end  
    
    %Get extremes of depth
    depthValues = vertices*optional_up';
    top = max(depthValues);
    bottom = min(depthValues);
    
    %Get one slice from withing on tenth of the front, and one from within
    %one tenth of the back vertex
    topHalf = bottom + (top-bottom)*0.5;
    topVertices = vertices(depthValues > topHalf, :);
   
    %Could extract contour here, but faster without it
    
    %Get a set of slots from top half
    slotVertices = slotsFromContour(topVertices, optional_up, normal);
end