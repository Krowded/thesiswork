function returnStructure = loadMergeFolder(filepath)
    [fileID,message] = fopen(filepath,'rt');	% open file in read text mode

    if fileID == -1, error(message); end

    returnStructure = struct();
    
    %First two rows are the target and exemplar respectively
    returnStructure.targetFolder = string(fgetl(fileID));
    returnStructure.exemplarFolder = string(fgetl(fileID));
    returnStructure.parts = strings(0,2);

    %Read line by line until eof
    i = 1;
    while ~feof(fileID)
        line = fgetl(fileID);

        %Allow for comments
        if startsWith(line, '//')
            continue;
        end

        %Divide
        tokens = textscan(line, '%s');
        tokens = tokens{1};

        %Store
        returnStructure.parts(i,1) = string(tokens(1));
        returnStructure.parts(i,2) = string(tokens(2));
        
        i = i+1;
    end
end