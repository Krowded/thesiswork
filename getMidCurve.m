%Tries to compute a the central curve of a model (assumes entry and exit
%directions are normalized)
function [curvePoints] = getMidCurve(model, entryDirection, exitDirection, curveMaxLength, precision)
    if nargin < 3
        exitDirection = entryDirection;
    end
    if nargin < 4
        curveMaxLength = Inf;
    end
    if nargin < 5
        precision = 100;
    end
    points = model.vertices; 
    
    
    %Start by getting entry centroid
    ydir = entryDirection;
    if norm(abs(ydir) - [0 0 1]) > 0.001
        temp = [0 0 1];
    else
        temp = [0 1 0];
    end
    xdir = cross(ydir,temp);
    zdir = cross(xdir,ydir);
    heights = points*ydir';
    maxHeight = max(heights);
    minHeight = min(heights);
    segment = points(heights < (maxHeight - minHeight)/precision + minHeight, :);
    startPoint = getCentroidLocal(segment, xdir, ydir, zdir);
    startPoint = startPoint - (startPoint*ydir')*ydir + minHeight*ydir;
    
    %And exit
    ydir = exitDirection;
    if norm(abs(ydir) - [0 0 1]) > 0.001
        temp = [0 0 1];
    else
        temp = [0 1 0];
    end
    xdir = cross(ydir,temp);
    zdir = cross(xdir,ydir);
    heights = points*ydir';
    maxHeight = max(heights);
    minHeight = min(heights);
    segment = points(heights > maxHeight - (maxHeight - minHeight)/precision, :);
    endPoint = getCentroidLocal(segment, xdir, exitDirection, zdir);
    endPoint = endPoint - (endPoint*ydir')*ydir + maxHeight*ydir;
   
    %Get entry slopes (exit automatically zero since we use it as basis)
    entryProjection = normalize((entryDirection * ydir')*ydir + (entryDirection * xdir')*xdir);
    if any(isnan(entryProjection))
        angleInX = 0;
    else
        angleInX = atan2(fastCross(xdir, entryProjection) * ydir', xdir * entryProjection');
    end
    entryProjection = normalize((entryDirection * ydir')*ydir + (entryDirection * zdir')*zdir);
    if any(isnan(entryProjection))
        angleInZ = 0;
    else
        angleInZ = atan2(fastCross(zdir, entryProjection) * ydir', zdir * entryProjection');  
    end
    
    
    %Change basis
    x = points*xdir';
    y = points*ydir';
    z = points*zdir';
    
    %XY-plane
    sp = [startPoint*ydir', startPoint*xdir'];
    ep = [endPoint*ydir', endPoint*xdir'];
    [~, yout, xout] = slmengine(y,x,'plot','off','xy',[sp; ep], 'xyp', [sin(angleInX) 0]);
    underStartIndicesX = find(yout < sp(1));
    overEndIndicesX = find(yout > ep(1));
    
    %YZ-plane
    sp = [startPoint*ydir', startPoint*zdir'];
    ep = [endPoint*ydir', endPoint*zdir']; 
    [~, yout, zout] = slmengine(y,z,'plot', 'on', 'knots', 10,'xy',[sp; ep], 'xyp', [sin(angleInZ) 0]);
    underStartIndicesZ = find(yout < sp(1));
    overEndIndicesZ = find(yout > ep(1));
    
    %Remove overshot
    if min(underStartIndicesX) < min(underStartIndicesZ)
        underStartIndices = underStartIndicesX;
    else
        underStartIndices = underStartIndicesZ;
    end
    
    if max(overEndIndicesX) > max(overEndIndicesZ)
        overEndIndices = underStartIndicesX;
    else
        overEndIndices = underStartIndicesZ;
    end
    
    xout([underStartIndices overEndIndices]) = [];    
    yout([underStartIndices overEndIndices]) = [];
    zout([underStartIndices overEndIndices]) = [];
     
%     figure(1)
%     plot(yout, zout)
%     zout = smooth(yout,zout,0.1,'loess');
    figure(2)
    plot(yout, zout)
    
    
    %Get down to maximum size
    if length(yout) > curveMaxLength
        samplePoints = yout(1):(yout(end)/curveMaxLength):yout(end);
        
        %Make sure the endpoint makes it in
        if length(samplePoints) < curveMaxLength
            samplePoints(end+1) = yout(end);
        else
            samplePoints(end) = yout(end);
        end
        
        xout = interp1(yout, xout, samplePoints);
        zout = interp1(yout, zout, samplePoints);
        yout = samplePoints;
    end
    
    
    %Collect and change basis back
    curvePoints = bsxfun(@times, xout', xdir) + bsxfun(@times, yout', ydir) + bsxfun(@times, zout', zdir);
    figure(3)
    betterpcshow([model.vertices; curvePoints])
    
    %In case we wanna change how this is calculated
    function centroid = getCentroidLocal(points, x, y ,z)
        xp = points*x';
        minx = min(xp);
        yp = points*y';
        miny = min(yp);
        zp = points*z';
        minz = min(zp);
        midX = (max(xp) - minx)/2 + minx;
        midY = (max(yp) - miny)/2 + miny;
        midZ = (max(zp) - minz)/2 + minz;
        centroid = midX*x + midY*y + midZ*z;
    end
end