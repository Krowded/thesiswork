%Takes an array of points and another point
%Returns an array of the angle between each vector from the center to each
%point, in order
function anglesBetweenPoints = getAnglesBetweenPoints(points, center)
    if nargin < 2
        center = [0 0 0];
    end

    anglesBetweenPoints = NaN(size(points,1),1);
    for i = 1:(size(points,1)-1)        
        vec1 = normalize(points(i,:) - center);
        vec2 = normalize(points(i+1,:) - center);
        anglesBetweenPoints(i) = real(acos(dot(vec1,vec2)));
    end
    
    %And finally the angle between the last and first point
    vec1 = normalize(points(end,:) - center);
    vec2 = normalize(points(1,:) - center);
    anglesBetweenPoints(end) = real(acos(dot(vec1,vec2)));
end