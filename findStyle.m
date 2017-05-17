function [foundationCurves, roofStruct, partsStructs] = findStyle(style, partNames)
    roofStruct = findRandom([string('name'), string('style')], [string('roof'), style]);
    foundation = findRandom([string('name'), string('style')], [string('foundation'), style]);
    foundationCurves = foundation.curves;
    
    partsStructs = cell.empty;
    for i = 1:length(partNames)
        name = partNames(i);
        foundParts = findRandom([string('name'), string('style')], [string(name), string(style)]);
        
        if isempty(foundParts)
            warning(['No part with name [' char(name) '] found'])
        end
        
        partsStructs = [partsStructs foundParts];
    end
    
    %Turn curve vertices into curveFunctions
    for i = 1:length(foundation.curves)
        foundationCurves(i).curveFunction = @(xq) interp1(foundationCurves(i).vertices(:,2), foundationCurves(i).vertices(:,1), xq, 'linear', 'extrap');
    end
end