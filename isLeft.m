%Returns 1 if PointC is left of the line from PointA to PointB or zero
%otherwise
%(assuming x-y coordinate system)
function bool = isLeft(PointA, PointB, PointC)
     bool = ((PointB(1) - PointA(1))*(PointC(2) - PointA(2)) - (PointB(2) - PointA(2))*(PointC(1) - PointA(1))) > 0;
end