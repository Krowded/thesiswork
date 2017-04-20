%Creates holes in the wall vertices
%Assumes wall is two polygons thick
function wallStruct = retriangulateWall(wallStruct, holeStructs)
    if nargin < 2
        holeStructs = [];
    end

    normal = wallStruct.frontNormal;
    
    %Collect all holes in single structure
    concatenatedHoles = newHoleStruct([],[]);
    concatenatedHoles.holeLength = [];
    if ~isempty(holeStructs)
        for i = length(holeStructs)
            if holeStructs(i).holeLength < 3
                continue;
            end
            concatenatedHoles.frontIndices = [concatenatedHoles.frontIndices; holeStructs(i).frontIndices];
            concatenatedHoles.backIndices = [concatenatedHoles.backIndices; holeStructs(i).backIndices];
            concatenatedHoles.holeLength = [concatenatedHoles.holeLength; holeStructs(i).holeLength];
        end
    end

    %Retriangulate and append
    faces = retriangulateSurface(wallStruct.vertices, wallStruct.frontIndices, concatenatedHoles.frontIndices, concatenatedHoles.holeLength, normal);
    faces = [faces; retriangulateSurface(wallStruct.vertices, wallStruct.backIndices, concatenatedHoles.backIndices, concatenatedHoles.holeLength, -normal)];
    
    %Create faces between the depth levels ("window sills")
    wallStruct.faces = [faces; createFacesBetweenContours(holeStructs)];
end