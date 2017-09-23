%Curves roof according to curveStructs. Assumes the zx-plane is the ground
function roofStruct = curveRoof(roofStruct, curveFunction, iterations)
    if nargin < 3
        iterations = 1;
    end

    %Get edge points
    minHeight = min(roofStruct.vertices*roofStruct.upVector');
    maxHeight = max(roofStruct.vertices*roofStruct.upVector');
    
    %Remove current curve
    roofStruct = removeRoofCurve(roofStruct, minHeight, maxHeight);

    %Add new curve
    for i = 1:iterations
        roofStruct.vertices = curveVertices(roofStruct.vertices, curveFunction, roofStruct.upVector, roofStruct.frontVector, minHeight, maxHeight);
        try
            roofStruct.slots = curveVertices(roofStruct.slots, curveFunction, roofStruct.upVector, roofStruct.frontVector, minHeight, maxHeight);
        catch
            warning('no slots found');
        end
    end
end