function curveStruct = getCurveUnderRoof(roofStruct, wallStruct)
    curveStruct = struct('curveFunction', @deal,'curveLength',[]);    
    [curveStruct.curveFunction, curveStruct.curveLength] = getCurveUnderModel(roofStruct, wallStruct);
end