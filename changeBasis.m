function [vertices] = changeBasis(vertices, zdirection, ydirection, xdirection)
    if nargin < 3
        B = getBaseTransformationMatrix(zdirection);
    elseif nargin < 4
        xdirection = normalize(cross(ydirection, zdirection));
        B = [xdirection' ydirection' zdirection']
    else
        B = [xdirection' ydirection' zdirection'];
    end
    
    Binv = inv(B);
    vertices = matrixMultByRow(vertices, Binv);
end