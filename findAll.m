%Returns a cell array containing structs of each matching entry found
function models = findAll(keys, values)
    cursor = findInDB(keys,values);
    numberOfModelsFound = cursor.count;
    
    models = cell(numberOfModelsFound,1);
    for i = 1:numberOfModelsFound
        cursor.next;
        objString = char(cursor.curr.toString);
        model = jsondecode(objString);
        model.filepaths = string(model.filepaths); %Maybe generalize...
        models{i} = model;
    end
end