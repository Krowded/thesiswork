function yq = customInterpolation(x, y, xq, extrapolationPoints, halfwayPoint)
    if xq < halfwayPoint
        yq = interp1(x, y, xq, 'linear', extrapolationPoints(1));
    else
        yq = interp1(x, y, xq, 'linear', extrapolationPoints(2));
    end
end