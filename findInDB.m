function resultCursor = findInDB(keys, values)
    keys = string(keys);
    values = string(values);

    import com.mongodb.*;
    query = BasicDBObject();
    for i = 1:length(keys)
        query.put(char(keys(i)),char(values(i)));
    end
    projection = BasicDBObject();
    projection.put('_id',0);
    
    global collection;
    resultCursor = collection.find(query, projection);
end