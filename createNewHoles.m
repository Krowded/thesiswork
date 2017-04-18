%Creates holes in the wall vertices
%Assumes wall is two polygons thick
function [faces] = createNewHoles(vertices, faces, holeIndices, lengthsOfHoles, normal, optional_normals)
    if nargin < 6
        normals = calculateNormals(vertices,faces); %Could save a couple of calculations doing this later, but it hurts readability
    else
        normals = optional_normals;
    end

    %Remove sideways faces (and their normals)
    facesToRemove = getPerpendicularFaceIndices(normals, normal);
    faces(facesToRemove,:) = [];
    normals(facesToRemove,:) = [];
    
    %Get vertices of each side of the wall
    frontWallIndices = getSameDirectionVertexIndices(faces, normals, normal);
    backWallIndices = getSameDirectionVertexIndices(faces, normals, -normal);
    
    %Remove faces that will be retriangulated
    indicesToBeRetriangulated = unique([frontWallIndices; backWallIndices]);
    faces(indicesToBeRetriangulated,:) = [];
    %normals(indicesToBeRetriangulated,:) = []; %Not applicable atm, but it might be needed later
    
    %Divide front and back of holes   
    frontHoleIndices = extractOneSideHoleIndices(holeIndices, lengthsOfHoles, 'front');
    backHoleIndices = extractOneSideHoleIndices(holeIndices, lengthsOfHoles, 'back');

    %Retriangulate and append
    faces = [faces; retriangulateSurface(vertices, frontWallIndices, frontHoleIndices, lengthsOfHoles, normal)];
    faces = [faces; retriangulateSurface(vertices, backWallIndices, backHoleIndices, lengthsOfHoles, -normal)];
    
    %Create faces between the depth levels ("window sills")
    faces = [faces; createFacesBetweenContours(holeIndices, lengthsOfHoles)];
end