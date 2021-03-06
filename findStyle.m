function [foundationCurves, roofStruct, partsStructs] = findStyle(styles, partClasses)
    queryCell{1} = string('roof');
    queryCell{2} = styles;
    roofStruct = findRandom([string('class'), string('style')], queryCell);
    
    queryCell{1} = string('foundation');
    foundation = findRandom([string('class'), string('style')], queryCell);
    
    
    %Calculate curve from foiundation if needed
    if isfield(foundation, 'type') && ~strcmp(foundation.type, 'nocurve')
        foundationCurves = foundation.curves;
    else
        foundationCurves = [];
    end
    
    partsStructs = cell.empty;
    for i = 1:length(partClasses)
        class = partClasses(i);
        queryCell{1} = string(class);
        foundParts = findRandom([string('class'), string('style')], queryCell);
        
        for j = 1:length(foundParts)
            foundParts(j).upVector = foundParts(j).upVector';
            foundParts(j).frontVector = foundParts(j).frontVector';
        end
        
        if isempty(foundParts)
            warning(['No part of class [' char(class) '] found'])
            continue;
        end
        
        partsStructs = [partsStructs foundParts];
    end
    
    %Load mandatory connection (ignoring any but roof atm)
    if isfield(roofStruct, 'connections')
        for j = 1:length(roofStruct.connections)
            connectionNameAndLikelyHood = strsplit(roofStruct.connections(j), '-');
            connectionName = connectionNameAndLikelyHood{1};
            try
                likelyHood = str2double(connectionNameAndLikelyHood{2});
            catch
                likelyHood = 1;
            end
            
            %Only add if it a roll beats it
            if rand() < likelyHood 
                warning('Added connection to roof')
                continue;
            end
            
            newPart = findFirst(string('name'), string(connectionName));
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