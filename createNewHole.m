function [vertices, faces] = createNewHole(vertices, faces, newVertices, normal, optional_normals)
    if nargin < 6
        normals = calculateNormals(vertices,faces);
    else
        normals = optional_normals;
    end
    
    %Prep
    normal = normalize(normal);
    originalVertexLength = size(vertices,1);
    
    %Remove sideways faces (and their normals)
    facesToRemove = getPerpendicularFaceIndices(normals, normal);
    faces(facesToRemove,:) = [];
    normals(facesToRemove,:) = [];

    %Add a hole to each side of the wall
    for j = 1:2
        if j == 2
            normal = -normal;
        end
        
        %Get faces with matching normal
        facesToCheck = getSameDirectionFaceIndices(normals, normal);

        %Prepare vertices for triangulation
        indices = unique(faces(facesToCheck,:));
        depth = mean(normal*vertices(indices,:)'); %(Dot mult)
        holeVertices = newVertices - normal.*(newVertices*normal') + normal.*depth;

        previousVerticesLength = size(vertices,1);
        vertices = [vertices; holeVertices];
        newVertexIndices = (previousVerticesLength+1):size(vertices,1);
        indices = [ indices; newVertexIndices(:) ];
        %Set up constraint edges
        edges = createEdgeLoop(newVertexIndices);
        
        %Remove faces that will be retriangulated
        faces(facesToCheck,:) = [];
        normals(facesToCheck,:) = [];
        faces = [faces; constrainedDelaunayTriangulation(vertices, indices, edges, normal)];
    end
    
    %Create faces between the depth levels ("window sills")
    numberOfNewVerticesPerLevel = size(newVertices,1);
    faces = [faces; fillWindingFaces(numberOfNewVerticesPerLevel, 2, (originalVertexLength+1):size(vertices,1))];
    
    %Clean up
    [vertices, faces] = removeUnreferencedVertices(vertices,faces);
end