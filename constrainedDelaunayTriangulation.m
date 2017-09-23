%Does a constrained Delaunay triangulation over the vertices given by
%vertexIndices by flattening them in the normal direction
function [faces] = constrainedDelaunayTriangulation(vertices, vertexIndices, edges, frames, normal)
    flattenedVertices = flattenVertices(vertices(vertexIndices,:), normal);
    
    %Move edge indices to current values
    tempEdges = edges;
    tempFrames = frames;
    for i = 1:length(vertexIndices)
        tempEdges(edges(:) == vertexIndices(i)) = i;
        tempFrames(frames(:) == vertexIndices(i)) = i;
    end
    edges = tempEdges;
    frames = tempFrames;    
    
    %Remove duplicates
    [flattenedVertices, combined, remainingIndices] = remove2DDuplicatePoints(flattenedVertices, [edges; frames]);
    edges = combined(1:size(edges,1),:);
    frames = combined(size(edges,1)+1:end,:);
    vertexIndices = vertexIndices(remainingIndices);
    
    %Retriangulate
    if isempty(edges) && isempty(frames) %Unconstrained
        unconstrainedTriangulation = delaunayTriangulation(flattenedVertices);
        faces = unconstrainedTriangulation.ConnectivityList;
    elseif isempty(frames) %Constrained by holes
        constrainedTriangulation = delaunayTriangulation(flattenedVertices, edges);
        %Exclude things inside of the edges
        outside = ~isInterior(constrainedTriangulation);
        faces = constrainedTriangulation.ConnectivityList(outside,:);
    elseif isempty(edges) %Constrained by frame
        constrainedTriangulation = delaunayTriangulation(flattenedVertices, frames);
        %Exclude things outside the frame
        inside = isInterior(constrainedTriangulation);
        faces = constrainedTriangulation.ConnectivityList(inside,:);
    else
        combined = [edges; frames];
        constrainedTriangulation = delaunayTriangulation(flattenedVertices, combined);
        
        %Exclude things outside
        inside = isInterior(constrainedTriangulation);
        faces = constrainedTriangulation.ConnectivityList(inside,:);
        
        %Exclude things inside the edges
        holeEdgeIndices = unique(edges(:));
        faces = removeFacesWithOnlyIndices(faces, holeEdgeIndices);
    end
    
    %Restore indices to correct values
    tempFaces = faces;
    for i = 1:length(vertexIndices)
        tempFaces(faces(:) == i) = vertexIndices(i);
    end
    faces = tempFaces;
end