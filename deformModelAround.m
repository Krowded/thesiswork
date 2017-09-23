function deformedModel = deformModelAround(model, curveFunction)
    meanPoint = [0 0 0];
    meanPoint(1) = (max(model.vertices(:,1)) + min(model.vertices(:,1)))/2;
    meanPoint(2) = (max(model.vertices(:,2)) + min(model.vertices(:,2)))/2;
    meanPoint(3) = (max(model.vertices(:,3)) + min(model.vertices(:,3)))/2;
    up = model.upVector;
    
    maxPoint = [max(model.vertices(:,1)) max(model.vertices(:,2)) max(model.vertices(:,3))];
    maxPoint = maxPoint - (maxPoint*up')*up;

    maxHeight = max(model.vertices*up');
    minHeight = min(model.vertices*up');
    scale = 100/(maxHeight-minHeight);
    invscale = 1/scale;
    
    baseDistance = norm(maxPoint);
    normals = model.vertexNormals;
    distanceFromMid = model.vertexNormals;
    for i = 1:size(model.vertices,1)
        normal = model.vertexNormals(i,:);
        normal = normal - (normal*up')*up;
        
        vecFromMid = model.vertices(i,:) - meanPoint;
        
        if norm(normal) > 0.000001
            normals(i,:) = normalize(normal);
        else
            normals(i,:) = normalize(vecFromMid);
        end        
        
        distanceFromMid(i) = dot(vecFromMid, normals(i,:));
        
        if distanceFromMid(i) <= 0 %Skip pointing inwards
            continue;
        end
        
%         baseDistance = max(baseDistance, distanceFromMid(i));
    end
    
    for i = 1:size(model.vertices,1)        
        %If pointing inward, skip.
        if distanceFromMid(i) <= 0
            continue;
        end
         
        % Flatten to base
%         model.vertices(i,:) = model.vertices(i,:) - normals(i,:)*(distanceFromMid(i) - baseDistance);
        model.vertices(i,:) = model.vertices(i,:) - (model.vertices(i,:)*normals(i,:)' + meanPoint*normals(i,:)' + baseDistance)*normals(i,:);
    
        %Apply curve function to each vertex
        y = invscale*arrayfun(curveFunction, model.vertices(i,:)*up');
        model.vertices(i,:) = model.vertices(i,:) + 100*y*normals(i,:);
    end
    
    deformedModel = model;
end