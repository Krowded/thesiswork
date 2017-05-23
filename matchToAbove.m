%Projects each point to the face above it and adjusts its height to match
function [wallStruct, changedAndNewIndices] = matchToAbove(wallStruct, targetStruct)
    up = wallStruct.upVector;
    front = wallStruct.frontVector';
    side = wallStruct.sideVector';
    xvertices = targetStruct.vertices*side;
    zvertices = targetStruct.vertices*front;
    maxX = max(xvertices);
    minX = min(xvertices);
    maxZ = max(zvertices);
    minZ = min(zvertices);        

    changedAndNewIndices = [wallStruct.frontTopIndices; wallStruct.backTopIndices];

    tempTargetVertices = targetStruct.vertices;
    tempTargetFaces = targetStruct.faces;

    vertices = wallStruct.vertices(changedAndNewIndices,:);
    for j = 1:size(vertices,1)
        vertex = vertices(j,:);

        %Check if outside
        x = vertex*side;
        z = vertex*front;

        if ~(x > maxX || x < minX || z > maxZ || z < minZ)
            [~, distanceToIntersection] = rayFaceIntersect(tempTargetVertices, tempTargetFaces, vertex, up, 1);
            if ~isnan(distanceToIntersection)
                vertices(j,:) = vertex + distanceToIntersection*up;
            else
                %No intersection found
            end
        end
    end
    wallStruct.vertices(changedAndNewIndices,:) = vertices;
end