function newFaces = createFacesBetweenContours(contourIndices, lengthsOfContours)
%Create faces between the depth levels ("window sills")
     newFaces = [];
     for i = 1:length(lengthsOfContours)
         e = lengthsOfContours(i);
         startIndex = 2*sum(lengthsOfContours(1:(i-1))) + 1;
         endIndex = startIndex - 1 + 2*e;
         numberOfVerticesPerLevel = lengthsOfContours(i);
         newFaces = [newFaces; fillWindingFaces(numberOfVerticesPerLevel, 2, contourIndices(startIndex:endIndex))];
     end  
end