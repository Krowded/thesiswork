function [foundationCurves, roofStruct, partsStructs] = findStyle(style, partNames)
    roofStruct = findRandom([string('name'), string('style')], [string('roof'), style]);
    foundation = findRandom([string('name'), string('style')], [string('foundation'), style]);
    
    %Calculate curve from foiundation if needed
    if isfield(foundation, 'type') && ~strcmp(foundation.type, 'nocurve')
        foundationCurves = foundation.curves;
    else
        foundationCurves = [];
    end
    
    partsStructs = cell.empty;
    for i = 1:length(partNames)
        name = partNames(i);
        foundParts = findRandom([string('name'), string('style')], [string(name), string(style)]);
        
        for j = 1:length(foundParts)
            foundParts(j).upVector = foundParts(j).upVector';
            foundParts(j).frontVector = foundParts(j).frontVector';
        end
        
        if isempty(foundParts)
            warning(['No part with name [' char(name) '] found'])
            continue;
        end
        
        partsStructs = [partsStructs foundParts];
    end
    
    %Load mandatory connection (ignoring any but roof atm)
    if isfield(roofStruct, 'connections')
        for j = 1:length(roofStruct.connections)
            connectionName = roofStruct.connections(j);
            newPart = findRandom([string('name'), string('style')], [string(connectionName), string(style)]);
            newPart.upVector = newPart.upVector';
            newPart.frontVector = newPart.frontVector';
            partsStructs = [partsStructs newPart];
        end
    end
    
    %Turn curve vertices into curveFunctions
    for i = 1:length(foundationCurves)
        %Just return a constant if there is no curve (fewer interps)
        if abs(max(foundationCurves(i).vertices(:,1)) - min(foundationCurves(i).vertices(:,1))) < 0.0001
            foundationCurves(i).curveFunction = @(xq) foundationCurves(i).vertices(1,1);
            continue;
        end
        foundationCurves(i).curveFunction = @(xq) interp1(foundationCurves(i).vertices(:,2), foundationCurves(i).vertices(:,1), xq, 'linear', foundationCurves(i).vertices(end,1));
%         foundationCurves(i).curveFunction = @(xq) interp1(foundationCurves(i).vertices(:,2), foundationCurves(i).vertices(:,1), xq, 'linear', 'extrap'); %Extrapolating alternative
    end
end