% Returns index of the first face it intersects and the distance to it from
% the point
% If optional_lineIntersection is set to true it does line intersection instead of ray intersection
function [intersectedFaceIndex, distanceToIntersection] = rayFaceIntersect(vertices, faces, point, direction, optional_lineIntersection, optional_faceIndices)
    %Adjust for optional arguments
    if nargin < 5
        optional_lineIntersection = 0;
    end
    if nargin < 6
        optional_faceIndices = 1:size(faces,1);
    end
    
    direction = normalize(direction);
    faces = faces(optional_faceIndices,:);
    intersectedFaceIndex = [];
    distanceToIntersection = NaN;
    
    for i = 1:size(faces,1)
        triangle = vertices(faces(i,:),:);
        edge1 = triangle(2,:) - triangle(1,:);
        edge2 = triangle(3,:) - triangle(1,:);

        orthogonal = fastCross(direction, edge2);
        determinant = edge1*orthogonal';

        %Possible culling of backfaces
        %det < 0.0
        
        %Skip if parallel
        if abs(determinant) < 0.00001
            continue;
        end
        
        invDet = 1/determinant;
        
        pointToCorner = point - triangle(1,:);
        %u & v barycentric coordinates of intersection point
        u = invDet * (pointToCorner*orthogonal');

        if (u < 0.0 || u > 1.0)
            continue;
        end

        q = fastCross(pointToCorner, edge1);
        v = invDet * (direction*q');

        if (v < 0.0 || u + v > 1.0)
            continue;
        end

        % Compute where the intersection point is on the line
        distanceToIntersection = invDet * (edge2 * q');
        
        %If line intersection is all we care about
        if optional_lineIntersection
            intersectedFaceIndex = i;
            continue;
        end
        
        if (distanceToIntersection > 0.00001) %Ray intersection
            intersectedFaceIndex = i;
            break; %One face intersected is enough
        else % Intersects line in other direction
            continue;
        end
    end

    intersectedFaceIndex = optional_faceIndices(intersectedFaceIndex);
end