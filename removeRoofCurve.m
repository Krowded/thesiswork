%Straightens out a roof
function roofStruct = removeRoofCurve(roofStruct, minHeight, maxHeight)
    roofStruct.frontVector = -roofStruct.frontVector; %Turn around frontVector to get curve from the back of roof instead of front
    curve = getWallCurve(roofStruct);
    roofStruct.frontVector = -roofStruct.frontVector;
    curveFunction = @(xq) interp1(curve.vertices(:,2), curve.vertices(:,1), xq, 'linear', 'extrap');
    
    roofStruct.vertices = curveVertices(roofStruct.vertices, curveFunction, roofStruct.upVector, roofStruct.frontVector, minHeight, maxHeight);
    try
        roofStruct.slots = curveVertices(roofStruct.slots, curveFunction, roofStruct.upVector, roofStruct.frontVector, minHeight, maxHeight);
    catch
        warning('no slots found');
    end
end