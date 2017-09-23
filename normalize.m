%Normalizes a vector
function [u] = normalize(v)
    u = v./norm(v);
    if any(isinf(u)) || any(isnan(u))
        warning('Normalized to inf or nan')
    end
end