function fusedFoundationStruct = createFoundationRoofConnection(foundationStruct, roofStruct)
    up = foundationStruct.upVector;
    
    %Get part of roof touching foundation
    foundationHeights = foundationStruct.vertices*up';
    roofHeights = roofStruct.vertices*up';
    highestFoundationPoint = max(foundationHeights);
    highestRoofPoint = max(roofHeights);
    bottomTenthOfThat = highestFoundationPoint + (0.1*(highestRoofPoint - highestFoundationPoint));
    interestingRoofVertices = roofStruct.vertices(roofHeights <= bottomTenthOfThat,:);
    
    %Get highest part of foundation
    lowestFoundationPoint = min(foundationHeights);
    lowestRoofPoint = min(roofHeights);
    topTenthOfThat = lowestFoundationPoint + 0.9*(lowestRoofPoint - lowestFoundationPoint);
    indices = 1:size(foundationStruct.vertices,1);
    interestingFoundationVertexIndices = indices(foundationHeights >= topTenthOfThat);
    
    %Check if the foundation points are contained within the roof points
    %And if it is we don't need to continue. Return original struct.
    struct1 = struct('vertices', foundationStruct.vertices(interestingFoundationVertexIndices,:), 'frontNormal', foundationStruct.frontNormal, 'upVector', up);
    struct2 = struct('vertices', interestingRoofVertices);
    if isStruct1WithinStruct2(struct1, struct2)
        fusedFoundationStruct = foundationStruct;
        return;
    end
    
    %Get contour of roof    
    roofContour = extractSimplifiedContour3D(interestingRoofVertices, up);
    
    %Add roof
    foundationStruct.frontIndices = interestingFoundationVertexIndices';
    endIndex = size(foundationStruct.vertices,1);
        %Add second set of vertices (all "walls" are two sided)
    foundationStruct.vertices = [foundationStruct.vertices; foundationStruct.vertices(interestingFoundationVertexIndices,:) - 0.01*up];
    foundationStruct.backIndices = ((endIndex+1):size(foundationStruct.vertices))';
    foundationStruct.frontNormal = up;
    %Carve hole in roof
    [foundationStruct, holeStruct] = createHoleFromContour(foundationStruct, roofContour);
    
    %Retriangulate
    foundationStruct = retriangulateWall(foundationStruct, holeStruct);
    
    %Setup return model
    fusedFoundationStruct = foundationStruct;
end