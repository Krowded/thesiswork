function crossProduct = fastCross(vec1,vec2)
 % Calculate cross product
 crossProduct = [vec1(2).*vec2(3)-vec1(3).*vec2(2), vec1(3).*vec2(1)-vec1(1).*vec2(3), vec1(1).*vec2(2)-vec1(2).*vec2(1)]; 
end