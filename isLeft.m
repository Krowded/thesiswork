%Returns 1 if PointC is left of the line from PointA to PointB or zero
%otherwise
%Assuming xy coordinates
function [isCounterClockWise, isColinear] = isLeft(PointA, PointB, PointC)
    isCounterClockWise = 0;
    isColinear = 0;
    
    value = (PointB(1) - PointA(1))*(PointC(2) - PointA(2)) - (PointB(2) - PointA(2))*(PointC(1) - PointA(1));
      
     if abs(value) < 0.00001 %Colinear
         isColinear = 1;
     elseif value > 0 %Counter clockwise
         isCounterClockWise = 1;
     %else %Clockwise
     end
end