%Works the same as circshift, but always in dimension 1.
%Using this since the other is super slow for some reason?
function vector = customCircShift(vector, steps)
    temp = vector;
    vectorLength = size(vector,1); 
    
    vector(1:(vectorLength-steps),:) = temp((steps+1):end,:);
    vector((vectorLength-steps+1):end,:) = temp(1:steps,:);
end