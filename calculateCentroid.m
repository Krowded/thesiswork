function [centroid] = calculateCentroid(points, normal)
    if size(points,1) < 4
        centroid = mean(points);
    else        
        B = getBaseTransformationMatrix(normal);
        points = (B\points')';

        minx = min(points(:,1));
        maxx = max(points(:,1));
        miny = min(points(:,2));
        maxy = max(points(:,2));
        minz = min(points(:,3));
        maxz = max(points(:,3));
        centroid = (B*[mean([minx,maxx]); mean([miny,maxy]); mean([minz,maxz])])';
    end
end