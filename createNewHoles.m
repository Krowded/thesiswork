%Creates holes in the wall made up of the vertices
%Number of levels is 1 or 2 and describes if the wall is 2D or 3D (i.e.  if it's 1
%or 2 plygons deep)
function [vertices, faces] = createNewHoles(vertices, faces, holeIndices, lengthsOfHoles, normal, numberOfLevels, optional_normals)
    if nargin < 7
        normals = calculateNormals(vertices,faces); %Could save a couple of calculations doing this later, but it hurts readability
    else
        normals = optional_normals;
    end
    
    %Normalize for safety
    normal = normalize(normal);
    
    %Remove sideways faces (and their normals)
    facesToRemove = getPerpendicularFaceIndices(normals, normal);
    faces(facesToRemove,:) = [];
    normals(facesToRemove,:) = [];
    
    %Create edge loops for both front and back of wall
    frontEdges = [];
    frontHoleIndices = [];
    backEdges = [];
    backHoleIndices = [];
    for i = 1:length(lengthsOfHoles)
        for j = 1:numberOfLevels
            %Set up indices
            e = lengthsOfHoles(i);
            startIndex = 2*sum(lengthsOfHoles(1:(i-1))) + (j-1)*e + 1;
            endIndex = startIndex - 1 + e;
            
            %Set up constraint edges
            if j == 1
                frontEdges = [frontEdges; createEdgeLoops(holeIndices(startIndex:endIndex), lengthsOfHoles(i))];
                frontHoleIndices = [frontHoleIndices; holeIndices(startIndex:endIndex)];
            else
                backEdges = [backEdges; createEdgeLoops(holeIndices(startIndex:endIndex), lengthsOfHoles(i))];
                backHoleIndices = [backHoleIndices; holeIndices(startIndex:endIndex)];
            end
        end
    end

    %Get faces with matching normal (i.e. the front wall)
    frontFaces = getSameDirectionFaceIndices(normals, normal);
    frontWallIndices = unique(faces(frontFaces,:));
    backFaces = getSameDirectionFaceIndices(normals, -normal);
    backWallIndices = unique(faces(backFaces,:));
    
    
    %Remove faces that will be retriangulated
    indicesToBeRetriangulated = unique([frontWallIndices; backWallIndices]);
    faces(indicesToBeRetriangulated,:) = [];
    %normals(indicesToBeRetriangulated,:) = []; %Not applicable atm, but it might be needed later

    %Retriangulate and append
    frontIndices = unique([frontHoleIndices; frontWallIndices]);
    backIndices = unique([backHoleIndices; backWallIndices]);
    newFrontFaces = constrainedDelaunayTriangulation(vertices, frontIndices, frontEdges, normal);
    newBackFaces = constrainedDelaunayTriangulation(vertices, backIndices, backEdges, -normal);
    faces = [faces; newFrontFaces; newBackFaces];
    
     %Create faces between the depth levels ("window sills")
     faces = createFacesBetweenContours(faces, holeIndices, lengthsOfHoles);
     
     %Clean up
%     [vertices, faces] = removeUnreferencedVertices(vertices,faces);
end