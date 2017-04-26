function modelStruct = removeFacesAboveCurve(modelStruct, indices, curveFunction)
    %Get all faces of interest
    faceIndices = nan(size(modelStruct.faces,1));
    for i = 1:size(modelStruct.faces,1)
        if length(intersect(modelStruct.faces(i,:), indices)) == 3
            faceIndices(i) = i;
        end
    end
    faceIndices = faceIndices(~isnan(faceIndices));
    
    %Get basis change matrix
    zdirection = modelStruct.frontNormal;
    ydirection = modelStruct.upVector;
    xdirection = normalize(cross(ydirection, zdirection));
    B = [xdirection', ydirection', zdirection'];
    B = inv(B);
    
    %Get 2D points
    points = matrixMultByRow(modelStruct.vertices,B);
    points = points(:,[1 2]);
    
    %Check midpoint of each line vs curve, if it's above then remove it
    facesToRemove = nan(size(faceIndices));
    for i = 1:length(faceIndices)
        face = modelStruct.faces(faceIndices(i),:);
        point1 = points(face(1),:);
        point2 = points(face(2),:);
        point3 = points(face(3),:);
        
        if (isMidpointAboveCurve(point1, point2) ||...
            isMidpointAboveCurve(point1, point3) ||...
            isMidpointAboveCurve(point2, point3))
        
            facesToRemove(i) = faceIndices(i);
        end
    end
    facesToRemove = facesToRemove(~isnan(facesToRemove));
    
    %Remove faces above curve
    modelStruct.faces(facesToRemove,:) = [];
    
    function isAboveCurve = isMidpointAboveCurve(point1, point2)
        midpoint = (point2 - point1)/2 + point1;
        y = midpoint(2);
        curveY = curveFunction(midpoint(1));
        isAboveCurve = isnan(y) || y > curveY;
    end
end