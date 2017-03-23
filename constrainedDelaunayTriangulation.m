%Does a constrained Delaunay triangulation over the vertices given by
%vertexIndices by flattening them in the normal direction
function [faces] = constrainedDelaunayTriangulation(vertices, vertexIndices, edges, normal)
    %Flatten vertices
    B = getBaseTransformationMatrix(normal);
    Binv = B;
    vertices = matrixMultByRow(vertices(vertexIndices,:),Binv);
    flattenedVertices = vertices(:,1:2);
    
    %Translate the indices of edges
    tempEdges = edges;
    for i = 1:length(vertexIndices)
        tempEdges(edges(:) == vertexIndices(i)) = i;
    end
    edges = tempEdges;
    
    %Retriangulate
    constrainedTriangulation = delaunayTriangulation(flattenedVertices, edges);
    %Exclude things inside of the edges
    outside = ~isInterior(constrainedTriangulation);
    faces = constrainedTriangulation.ConnectivityList(outside,:);
    
    %Restore indices to correct values
    tempFaces = faces;
    for i = 1:length(vertexIndices)
        tempFaces(faces(:) == i) = vertexIndices(i);
    end
    faces = tempFaces;
end