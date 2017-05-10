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
        
        returnStructure.(partName) = struct('filepaths', [], 'shape', newModelStruct(), 'type', [], 'attributes', string.empty);
        returnStructure.(partName).name = partName;
        returnStructure.(partName).models = [];
        
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
                    
                    if length(tokens) > 2 %Only normal allowed at the moment
                        classifier = tokens{3};
                        switch classifier
                            case 'normal'
                                normal = [str2double(tokens{4}) str2double(tokens{5}) str2double(tokens{6})];
                                returnStructure.(partName).models(end).frontVector = normal;
                            otherwise
                                error(['Sub-classifier ' classifier ' unknown for type "filename"']);
                        end
                    end                   
                case 'normal' %Set normal
                    normal = [str2double(tokens{2}) str2double(tokens{3}) str2double(tokens{4})];
                    returnStructure.(partName).frontVector = normal;
                case 'up' %Set upVector
                    up = [str2double(tokens{2}) str2double(tokens{3}) str2double(tokens{4})];
                    returnStructure.(partName).upVector = up;
                    for i = 1:length(returnStructure.(partName).models) %Fill in extra parts...
                        returnStructure.(partName).models(i).upVector = up;
                    end
                case 'style'
                    style = string(tokens{2});
                    returnStructure.(partName).style = style;
                case 'shape' %Shape property is another filename
                    filepath = folderpath + string(tokens{2}); %Append if more than one shape has been given
                    returnStructure.(partName).shape = mergeModels([returnStructure.(partName).shape loadAndMergeModels(filepath)]);
                    returnStructure.(partName).shape.filepaths = [returnStructure.(partName).shape.filepaths; string(filepath)];
                case 'type'
                    type = string(tokens{2});
                    returnStructure.(partName).type = type;
                case 'attribute' %Used for later additions
                    attribute = string(tokens{2});
                    returnStructure.(partName).attributes(end+1) = attribute;                        
                otherwise
                    message = ['Unknown classifier: ' classifier ' when attempting to load ' folderpath];
                    error(message);
            end
        
            line = fgetl(fileID);
        end        
    end
end