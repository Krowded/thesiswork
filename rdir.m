%Recursively searches path for files with names containing searchterm
function [returnlist] = rdir(path, searchterm)
    returnlist = string.empty;

    folderContents = dir(char(path));
    for i = 3:length(folderContents) %Skip '.' and '..'
        folderpath = string(folderContents(i).folder);
        if folderContents(i).isdir
            returnlist = [returnlist; rdir(folderpath + '\' + folderContents(i).name, searchterm)];
        else
            if contains(folderContents(i).name, searchterm)
               returnlist = [returnlist; folderpath + '\' + folderContents(i).name];
            end
        end
    end
    
end