%Finds and returns the first one
function model = findFirst(keys, values)
    cursor = findInDB(keys,values);
    cursor.next;
    objString = char(cursor.curr.toString);
    model = jsondecode(objString);
    model.filepaths = string(model.filepaths); %Maybe generalize...
end