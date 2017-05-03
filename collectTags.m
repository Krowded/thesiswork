function [] = collectTags(folderpath)
    folderpath = string(folderpath);
    writefilepath = string(folderpath) + '\' + string('tags.txt');
    [writeFileID,message] = fopen(writefilepath,'w');	% open/create file in write mode, discarding old contents
    if writeFileID == -1, error(message); end
    
    %Get name of all folders
    folderContents = dir(char(folderpath));
    folders = folderContents([folderContents.isdir]);
    
    for i = 1:length(folders)
        %Skip dots
        if strcmp(folders(i).name, '.') || strcmp(folders(i).name, '..')
            continue;
        end
        
        folderpath = string(folders(i).folder) + '\' + string(folders(i).name);
        filepath = folderpath + '\' + string('info.txt');
        [fileID,message] = fopen(filepath,'rt');	% open file in read text mode
        if fileID == -1, error(message); end
        
        %Save full path
        fprintf(writeFileID, '%s\n', filepath);
        
        %Find style heading
        line = '';
        while ~strcmp(line, 'style')
            line = fgetl(fileID);
            if ~ischar(line), fclose(fileID); break; end %Done if EOF
        end
        
        %Read line by line until '.'
        line = fgetl(fileID);
        if ischar(line) %Skip if EOF
            while ~strcmp(line, '.')
                %Allow for comments
                if startsWith(line, '//')
                    line = fgetl(fileID);
                    continue;
                end

                %Record each style
                fprintf(writeFileID, '%s\n', line);

                line = fgetl(fileID);
                if ~ischar(line), fclose(fileID); break; end %Done if EOF
            end
        end
        
        %Add dot ending and close
        fprintf(writeFileID, '.\n');
        fclose(fileID);
    end
end