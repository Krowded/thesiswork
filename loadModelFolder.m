function returnStructure = loadModelFolder(folderpath)
    folderpath = string(folderpath);
    filepath = folderpath + '\' + string('info.txt');
    [fileID,message] = fopen(filepath,'rt');	% open file in read text mode

    if fileID == -1, error(message); end

    returnStructure = struct();
    while 1
        %First row is always name of part
        partName = fgetl(fileID);
        if ~ischar(partName), fclose(fileID); return; end %Done if EOF
        
        %Allow for comments
        if startsWith(partName, '//')
            continue;
        end
        
        returnStructure.(partName) = struct('shape', [], 'type', [], 'attributes', string.empty);
      
        %Read line by line until '.'
        line = fgetl(fileID);
        while ~strcmp(line, '.')
            %Allow for comments
            if startsWith(line, '//')
                line = fgetl(fileID);
                continue;
            end
            
            %Divide
            tokens = textscan(line, '%s');
            tokens = tokens{1};
            [index, isindexed] = str2num(tokens{1});
            
            if isindexed
                classifier = lower(tokens{2});
                switch classifier
                    case 'filename' %Load model from file
                        filepath = folderpath + '\' + string(tokens{3});
                        if ~isfield(returnStructure.(partName), 'models') || length(returnStructure.(partName).models) < index %Append if more than one filename has been given at same index
                            returnStructure.(partName).models(index) = loadAndMergeModels(filepath);
                        else
                            returnStructure.(partName).models(index) = mergeModels([returnStructure.(partName).models(index) loadAndMergeModels(filepath)]);
                        end
                        
                    case 'normal' %Set normal
                        normal = [str2double(tokens{3}) str2double(tokens{4}) str2double(tokens{5})];
                        returnStructure.(partName).models(index).frontNormal = normal;
                    case 'up' %Set upVector
                        up = [str2double(tokens{3}) str2double(tokens{4}) str2double(tokens{5})];
                        returnStructure.(partName).models(index).upVector = up;
                    case 'connection' %Specifies what other model is connected to it
                        %Append the new part
                        connectedPartName = string(tokens{3});
                        appendIndex = length(returnStructure.(partName).models(index).connections) + 1;
                        returnStructure.(partName).models(index).connections(appendIndex) = connectedPartName;
                end
            else
                classifier = lower(tokens{1});
                switch classifier
                    case 'shape' %Shape property is another filename
                        filepath = folderpath + '\' + string(tokens{2}); %Append if more than one shape has been given
                        returnStructure.(partName).shape = mergeModels([returnStructure.(partName).shape loadAndMergeModels(filepath)]);
                    case 'type'
                        type = string(tokens{2});
                        returnStructure.(partName).type = type;
                    case 'attribute' %Used for later additions
                        attribute = string(tokens{2});
                        returnStructure.(partName).attributes(end+1) = attribute;
                    otherwise
                        error('Unknown classifier: ' + classifier);
                end
            end
            
            line = fgetl(fileID);
        end
    end
end