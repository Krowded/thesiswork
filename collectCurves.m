function curveFunction = collectCurves(curveStructs, direction)
    %Get size of contribution from each curve
    shares = zeros(length(curveStructs),1);
    for j = 1:length(curveStructs)
        projection = dot(direction, curveStructs(j).normal);

        %Scale curve
        shares(j) = max(projection,0);
    end
    %Normalize shares so it adds up to 1
    shares = shares./sum(shares);

    %Gather contribution from each curve function
    curveFunction = @(xq) 0;
    for j = 1:length(curveStructs)
        %No need to do any interpolation for a zero share
        if shares(j) < 0.0001
            continue;
        end
        
        curveFunction = @(xq) curveFunction(xq) + curveStructs(j).curveFunction(xq)*shares(j);
    end
end