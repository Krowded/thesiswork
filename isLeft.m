%Returns 1 if PointC is left of the line from PointA to PointB or zero
%otherwise
%Assuming xy coordinates
function bool = isLeft(PointA, PointB, PointC)
     value = (PointB(1) - PointA(1))*(PointC(2) - PointA(2)) - (PointB(2) - PointA(2))*(PointC(1) - PointA(1));
     
     
     if abs(value) < 0.0001 %Colinear
         bool = 0;
     elseif value > 0.0001 %Counter clockwise
         bool = 1;
     %elseif value < 0.0001 %Clockwise
     else
         bool = 0;
     end
end