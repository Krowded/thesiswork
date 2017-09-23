function returnStructure = loadModelFolder(folderpath)
    folderpath = string(folderpath) + '\';
    filepath = folderpath + string('info.txt');
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
        
        returnStructure.(partName) = struct('filepaths', [], 'shape', newModelStruct(), 'style', string.empty, 'type', string.empty);
        returnStructure.(partName).name = string(partName);
        returnStructure.(partName).models = [];
        returnStructure.(partName).slotType = string('default');
        returnStructure.(partName).connections = [];
        
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
            
            classifier = lower(tokens{1});
            switch classifier
                case 'filename' 
                    %Load model from file
                    filepath = folderpath + string(tokens{2});
                    returnStructure.(partName).models = [returnStructure.(partName).models loadAndMergeModels(filepath)];
                    
                    %Add filepath to struct
                    returnStructure.(partName).filepaths = [returnStructure.(partName).filepaths; filepath];
                    returnStructure.(partName).models(end).filepaths = [returnStructure.(partName).models(end).filepaths; filepath];
                    
                    currentIndex = 3;
                    totalTokens = length(tokens);
                    while currentIndex < totalTokens
                        classifier = tokens{currentIndex};
                        switch classifier
                            case 'normal'
                                normal = [str2double(tokens{currentIndex+1}) str2double(tokens{currentIndex+2}) str2double(tokens{currentIndex+3})];
                                returnStructure.(partName).models(end).frontVector = normal;
                            case 'up'
                                up = [str2double(tokens{currentIndex+1}) str2double(tokens{currentIndex+2}) str2double(tokens{currentIndex+3})];
                                returnStructure.(partName).models(end).upVector = up;
                            otherwise
                                error(['Sub-classifier ' classifier ' unknown for type "filename"']);
                        end
                        currentIndex = currentIndex + 4;
                    end                   
                case 'normal' %Set normal
                    normal = [str2double(tokens{2}) str2double(tokens{3}) str2double(tokens{4})];
                    returnStructure.(partName).frontVector = normal;
                case 'up' %Set upVector
                    up = [str2double(tokens{2}) str2double(tokens{3}) str2double(tokens{4})];
                    returnStructure.(partName).upVector = up;
                case 'style'
                    style = string(tokens{2});
                    returnStructure.(partName).style = [returnStructure.(partName).style; style];
                case 'shape' %Shape property is another filename
                    filepath = folderpath + string(tokens{2}); %Append if more than one shape has been given
                    returnStructure.(partName).shape = mergeModels([returnStructure.(partName).shape loadAndMergeModels(filepath)]);
                    returnStructure.(partName).shape.filepaths = [returnStructure.(partName).shape.filepaths; string(filepath)];
                case 'type' %Denotes if it cuts into a wall or not
                    type = string(tokens{2});
                    returnStructure.(partName).type = type;
                case 'slottype' %How it attaches to other things
                    slotType = string(tokens{2});
                    returnStructure.(partName).slotType = slotType;         
                case 'connections' %What else needs to be loaded in when it's chosen
                    connections = string(tokens(2:end));
                    returnStructure.(partName).connections = string([returnStructure.(partName).connections; connections]);
                otherwise
                    message = char(strjoin(['Unknown classifier: ' classifier ' when attempting to load ' folderpath]));
                    error(message);
            end
        
            line = fgetl(fileID);
            if strcmp(line, '.')
                returnStructure.(partName) = finishUpLocal(returnStructure.(partName));
            end
        end
    end
    
    
    %Adds in defaults optional parts
    function part = finishUpLocal(part)
        for i = 1:length(part.models)
            if isempty(part.models(i).upVector)
                part.models(i).upVector = part.upVector;
            end
            
            if isempty(part.models(i).frontVector)
                part.models(i).frontVector = part.frontVector;
            end
        end
    end
end