%Normalizes a vector
function [v] = normalize(v)
    v = v./norm(v);
    if isinf(v)
        error('Normalized to inf')
    end
end