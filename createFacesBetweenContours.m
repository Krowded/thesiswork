function faces = createFacesBetweenContours(faces, contourIndices, lengthsOfContours)
%Create faces between the depth levels ("window sills")
     for i = 1:length(lengthsOfContours)
         e = lengthsOfContours(i);
         startIndex = 2*sum(lengthsOfContours(1:(i-1))) + 1;
         endIndex = startIndex - 1 + 2*e;
         numberOfVerticesPerLevel = lengthsOfContours(i);
         faces = [faces; fillWindingFaces(numberOfVerticesPerLevel, 2, contourIndices(startIndex:endIndex))];
     end  
end