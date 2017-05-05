function curveStruct = getCurveUnderRoof(roofStruct, wallStruct)
    curveStruct = struct('curveFunction', '','curveLength',[]);    
    [curveStruct.curveFunction, curveStruct.curveLength] = getCurveUnderModel(roofStruct, wallStruct);
end