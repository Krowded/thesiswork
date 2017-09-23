%Creates holes in the wall vertices
%Assumes wall is two polygons thick
function wallStruct = retriangulateWall(wallStruct, holeStructs)
    if nargin < 2
        holeStructs = [];
    end
    
    %Collect all holes in single structure
    concatenatedHoles = newHoleStruct([],[]);
    concatenatedHoles.frontHoleLength = [];
    concatenatedHoles.backHoleLength = [];
    if ~isempty(holeStructs)
        for i = 1:length(holeStructs)
            if holeStructs(i).holeLength < 3
                continue;
            end
            concatenatedHoles.frontIndices = [concatenatedHoles.frontIndices; holeStructs(i).frontIndices];
            concatenatedHoles.backIndices = [concatenatedHoles.backIndices; holeStructs(i).backIndices];
            concatenatedHoles.frontHoleLength = [concatenatedHoles.frontHoleLength; holeStructs(i).holeLength];
            concatenatedHoles.backHoleLength = [concatenatedHoles.backHoleLength; holeStructs(i).holeLength];
        end
    end
    
    %A frame is the contour surrounding the wall
    concatenatedFrames = newHoleStruct([],[]);
    concatenatedFrames.frontFrameLength = [];
    concatenatedFrames.backFrameLength = [];

    frameFront = [flip(wallStruct.gridIndicesFront(2:end,1)); wallStruct.frontTopIndices; wallStruct.gridIndicesFront(2:end,end); flip(wallStruct.gridIndicesFront(end,:))'];
    frameFront = unique(frameFront, 'stable'); %Remove the duplicates at the corners
    concatenatedFrames.frontIndices = [concatenatedFrames.frontIndices; frameFront];
    concatenatedFrames.frontFrameLength = [concatenatedFrames.frontFrameLength; length(frameFront)];
    
    frameBack = [flip(wallStruct.gridIndicesBack(1,:))'; wallStruct.backTopIndices; wallStruct.gridIndicesBack(end,:)'; flip(wallStruct.gridIndicesBack(:,end))];
    frameBack = unique(frameBack, 'stable'); %Remove the duplicates at the corners
    concatenatedFrames.backIndices = [];%[concatenatedFrames.backIndices; frameBack];
    concatenatedFrames.backFrameLength = [];% [concatenatedFrames.backFrameLength; length(frameBack)];
    
    
    %Remove faces to be retriangulated
    wallStruct.faces = [];
    
    %Retriangulate and append
    faces = retriangulateSurface(wallStruct.vertices, wallStruct.frontIndices, concatenatedHoles.frontIndices, concatenatedHoles.frontHoleLength, concatenatedFrames.frontIndices, concatenatedFrames.frontFrameLength, wallStruct.frontVector);
    faces = [faces; retriangulateSurface(wallStruct.vertices, wallStruct.backIndices, concatenatedHoles.backIndices, concatenatedHoles.backHoleLength, concatenatedFrames.backIndices, concatenatedFrames.backFrameLength, -wallStruct.frontVector)];
    
    %Create faces between the depth levels ("window sills")
    wallStruct.faces = [wallStruct.faces; faces; createFacesBetweenContours(holeStructs)];
end