function modelStruct = removeFacesAboveFaces(modelStruct, indices, targetStruct)
    points = modelStruct.vertices;
    up = modelStruct.upVector;

    %Get all faces of interest
    faceIndices = nan(size(modelStruct.faces,1));
    for i = 1:size(modelStruct.faces,1)
        if length(intersect(modelStruct.faces(i,:), indices)) == 3
            faceIndices(i) = i;
        end
    end
    faceIndices = faceIndices(~isnan(faceIndices));
        
    %Check midpoint of each line vs curve, if it's above then mark for removal
    facesToRemove = false(size(faceIndices,1),1);
    faces = modelStruct.faces(faceIndices,:);
    for i = 1:size(faces,1)
        face = faces(i,:);
        point1 = points(face(1),:);
        point2 = points(face(2),:);
        point3 = points(face(3),:);
        
        centroid = (point1 + point2 + point3) / 3;
        [~, distanceToIntersection] = rayFaceIntersect(targetStruct.vertices, targetStruct.faces, centroid, up, 1);
        isAboveCurve = distanceToIntersection < 0 && ~isnan(distanceToIntersection);
        
        if isAboveCurve%isCentroidAboveRoof(point1, point2, point3)
            facesToRemove(i) = 1;
        end
    end
    
    %Remove said faces
    modelStruct.faces(faceIndices(facesToRemove),:) = [];
    
%     function isAboveCurve = isCentroidAboveRoof(point1, point2, point3)
%         centroid = (point1 + point2 + point3) / 3;
%         [~, distanceToIntersection] = rayFaceIntersect(targetStruct.vertices, targetStruct.faces, centroid, up, 1);
%         isAboveCurve = distanceToIntersection < 0 && ~isnan(distanceToIntersection);
%     end
end