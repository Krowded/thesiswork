%Create faces between the depth levels ("window sills")
function faces = createFacesBetweenContours(holes)
     faces = [];
     for i = 1:length(holes)
        if holes(i).holeLength < 3
            continue;
        end
        
        faces = [faces; fillWindingFaces(holes(i).holeLength, 2, [holes(i).frontIndices holes(i).backIndices])];
     end
end