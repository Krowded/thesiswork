%Check if, seen from above, struct1 is within the boundary of struct2
function isWithinBoundary = isStruct1WithinStruct2(struct1, struct2)
    y = struct1.upVector;
    z = struct1.frontNormal;
    x = normalize(cross(y,z));
    
    struct1X = struct1.vertices*x';
    struct1Z = struct1.vertices*z';
    vec1 = [struct1X struct1Z];
    max1X = max(struct1X);
    min1X = min(struct1X);
    max1Z = max(struct1Z);
    min1Z = min(struct1Z);
    
    struct2X = struct2.vertices*x';
    struct2Z = struct2.vertices*z';
    vec2 = [struct2X struct2Z];
    max2X = max(struct2X);
    min2X = min(struct2X);
    max2Z = max(struct2Z);
    min2Z = min(struct2Z);
    
    isWithinBoundary = max1X < max2X && min1X > min2X && max1Z < max2Z && min1Z > min2Z;
    
    %If false then we're done since it's definitely not true
    if ~isWithinBoundary, return; end

    %If true, then we need to check that the contours don't intersect
    vec1 = extractSimplifiedContour2D(vec1);
    vec2 = extractSimplifiedContour2D(vec2);
    isWithinBoundary = isempty(polyxpoly(vec1(:,1), vec1(:,2), vec2(:,1), vec2(:,2)));
end