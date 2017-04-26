% Returns indices of faces that the rays intersect
% If bothDirections is set to true it does line intersection instead of ray
% intersection
function [intersectedFaceIndices] = raysFacesIntersect(vertices, faces, points, direction, optional_lineIntersection, optional_faceIndices)
    %Adjust for optional arguments
    if nargin < 5
        optional_lineIntersection = 0;
    end
    if nargin < 6
        optional_faceIndices = 1:size(faces,1);
    end
    
    direction = normalize(direction);
    faces = faces(optional_faceIndices,:);
    intersectedFaceIndices = NaN(size(faces,1));
    depthOfIntersections = NaN(size(faces,1));
    currentIndex = 1;

    for i = 1:size(faces,1)
        triangle = vertices(faces(i,:),:);
        edge1 = triangle(2,:) - triangle(1,:);
        edge2 = triangle(3,:) - triangle(1,:);

        orthogonal = cross(direction, edge2);
        determinant = dot(edge1,orthogonal);

        %Possible culling of backfaces
        %det < 0.0
        
        %Skip if parallel
        if abs(determinant) < 0.00001
            continue;
        end
        
        invDet = 1/determinant;
        
        for j = 1:size(points,1)
            pointToCorner = points(j, :) - triangle(1,:);
            %u & v barycentric coordinates of intersection point
            u = invDet * dot(pointToCorner,orthogonal);
            
            if (u < 0.0 || u > 1.0)
                continue;
            end

            q = cross(pointToCorner,edge1);
            v = invDet * dot(direction,q);

            if (v < 0.0 || u + v > 1.0)
                continue;
            end

            %If line intersection is all we care about
            if optional_lineIntersection
                intersectedFaceIndices(currentIndex) = i;
                currentIndex = currentIndex + 1;
                continue;
            end
            
            % Compute where the intersection point is on the line
            lengthToIntersection = invDet * dot(edge2,q);

            if (lengthToIntersection > 0.00001) %Ray intersection
                depthOfIntersections(currentIndex) = lengthToIntersection;
                intersectedFaceIndices(currentIndex) = i;
                currentIndex = currentIndex + 1;
                break; %One ray intersecting is enough. Check next face
            else % Intersects line in other direction
                continue;
            end
        end
    end
    
    %Clear out crap and return
    intersectedFaceIndices = intersectedFaceIndices(~isnan(intersectedFaceIndices));
    if ~optional_lineIntersection
        depthOfIntersections = depthOfIntersections(~isnan(depthOfIntersections));
        [~,i] = sort(depthOfIntersections, 1, 'ascend');
        intersectedFaceIndices = optional_faceIndices(intersectedFaceIndices(i));
    else
        intersectedFaceIndices = optional_faceIndices(intersectedFaceIndices);
    end
    
end