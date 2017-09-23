% Returns index of the first face it intersects and the distance to it from each point
% If optional_lineIntersection is set to true it does line intersection instead of ray intersection
function [intersectedFaceIndex, distancesToIntersection] = raysFaceIntersect(vertices, faces, points, direction, optional_lineIntersection, optional_faceIndices)
    %Adjust for optional arguments
    if nargin < 5
        optional_lineIntersection = 0;
    end
    if nargin < 5
        faces = faces(optional_faceIndices,:);
    end
    
    direction = normalize(direction);
    intersectedFaceIndex = nan(size(points,1),1);
    distancesToIntersection = nan(size(points,1),1);
    
    for j = 1:size(points,1)
        point = points(j,:);
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

            if (u < 0 || u > 1)
                continue;
            end

            q = fastCross(pointToCorner, edge1);
            v = invDet * (direction*q');

            if (v < 0 || u + v > 1)
                continue;
            end

            % Compute where the intersection point is on the line
            distancesToIntersection(j) = invDet * (edge2 * q');

            if optional_lineIntersection || (distancesToIntersection(j) > 0.00001) %Either go for line intersection or Ray intersection
                intersectedFaceIndex(j) = i;
                break; %One face intersected is enough
            else % Intersects line in other direction
                continue;
            end
        end
    end

    if nargin > 5
        intersectedFaceIndex = optional_faceIndices(intersectedFaceIndex);
    end
end