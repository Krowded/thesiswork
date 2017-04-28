function modelStruct = removeFacesAboveCurve(modelStruct, indices, curveFunction)
    %Get all faces of interest
    faceIndices = nan(size(modelStruct.faces,1));
    for i = 1:size(modelStruct.faces,1)
        if length(intersect(modelStruct.faces(i,:), indices)) == 3
            faceIndices(i) = i;
        end
    end
    faceIndices = faceIndices(~isnan(faceIndices));
    
    %Get 2D points
    zdirection = modelStruct.frontNormal;
    ydirection = modelStruct.upVector;    
    points = changeBasis(modelStruct.vertices, zdirection, ydirection);
    points = points(:,[1 2]);
    
    %Check midpoint of each line vs curve, if it's above then remove it
    facesToRemove = nan(size(faceIndices));
    for i = 1:length(faceIndices)
        face = modelStruct.faces(faceIndices(i),:);
        point1 = points(face(1),:);
        point2 = points(face(2),:);
        point3 = points(face(3),:);
        
        if isCentroidAboveCurve(point1, point2, point3)
            facesToRemove(i) = faceIndices(i);
        end
    end
    facesToRemove = facesToRemove(~isnan(facesToRemove));
    
    %Remove faces above curve
    modelStruct.faces(facesToRemove,:) = [];
    
    function isAboveCurve = isCentroidAboveCurve(point1, point2, point3)
        centroid = (point1 + point2 + point3) / 3;
        x = centroid(1);
        y = centroid(2);
        curveY = curveFunction(x);
        isAboveCurve = isnan(y) || y > curveY;
    end
end