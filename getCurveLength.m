function curveLength = getCurveLength(curvePoints)
    if size(curvePoints,1) < 2
        curveLength = 0;
        return;
    end

    curveLength = sum(curvePoints(2:end) - curvePoints(1:(end-1)));
end