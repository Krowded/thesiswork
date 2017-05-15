%Finds and returns the first one
function model = findFirst(keys, values)
    cursor = findInDB(keys,values);
    if cursor.count == 0 
        error(['Nothing found for keys [' keys.join.char '] and values [' values.join.char ']'])
    end
    
    cursor.next;
    objString = char(cursor.curr.toString);
    model = jsondecode(objString);
    model.filepaths = string(model.filepaths); %Maybe generalize...
end