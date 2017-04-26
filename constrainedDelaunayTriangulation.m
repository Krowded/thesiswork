%Does a constrained Delaunay triangulation over the vertices given by
%vertexIndices by flattening them in the normal direction
function [faces] = constrainedDelaunayTriangulation(vertices, vertexIndices, edges, normal)
    flattenedVertices = flattenVertices(vertices(vertexIndices,:), normal);

    %Move edge indices to current values
    tempEdges = edges;
    for i = 1:length(vertexIndices)
        tempEdges(edges(:) == vertexIndices(i)) = i;
    end
    edges = tempEdges;
    
    %Remove duplicates
    [flattenedVertices, edges, remainingIndices] = remove2DDuplicatePoints(flattenedVertices, edges);
    vertexIndices = vertexIndices(remainingIndices);
    
    %Retriangulate
    if isempty(edges) %Unconstrained       
        unconstrainedTriangulation = delaunayTriangulation(flattenedVertices);
        faces = unconstrainedTriangulation.ConnectivityList;
    else %Constrained
        constrainedTriangulation = delaunayTriangulation(flattenedVertices, edges);
        %Exclude things inside of the edges
        outside = ~isInterior(constrainedTriangulation);
        faces = constrainedTriangulation.ConnectivityList(outside,:);
        
        global DEBUG;
        if DEBUG == 1
            DT = triangulation(faces, constrainedTriangulation.Points);
            triplot(DT);
        end
    end
    
    %Restore indices to correct values
    tempFaces = faces;
    for i = 1:length(vertexIndices)
        tempFaces(faces(:) == i) = vertexIndices(i);
    end
    faces = tempFaces;
end