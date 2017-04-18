%Retriangulates a surface, introducing holes
function retriangulatedFaces = retriangulateSurface(vertices, surfaceIndices, holeIndices, lengthsOfHoles, normal)
    %Create edge loops
    edges = createEdgeLoops(holeIndices, lengthsOfHoles);
    
    %Retriangulate and append
    indices = unique([holeIndices; surfaceIndices]);
    retriangulatedFaces = constrainedDelaunayTriangulation(vertices, indices, edges, normal);
end