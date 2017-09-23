%Retriangulates a surface, introducing holes
function retriangulatedFaces = retriangulateSurface(vertices, surfaceIndices, holeIndices, lengthsOfHoles, frameIndices, lengthsOfFrames, normal)
    %Create edge loops
    edges = createEdgeLoops(holeIndices, lengthsOfHoles);
    frames = createEdgeLoops(frameIndices, lengthsOfFrames);
    
    %Retriangulate and append
    indices = unique([holeIndices; surfaceIndices]);
    retriangulatedFaces = constrainedDelaunayTriangulation(vertices, indices, edges, frames, normal);
end