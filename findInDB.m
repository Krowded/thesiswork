function resultCursor = findInDB(keys, values)
%     keys = string(keys);
%     values = string(values);

    import com.mongodb.*;
    query = BasicDBObject();
    subQuery = BasicDBObject();
    for i = 1:length(keys)
        if length(values{i}) > 1
            for j = 1:length(values{i})
                q{j} = char(values{i}(j));
            end
            subQuery.put('$in', q);
            query.put(char(keys(i)), subQuery);
        else
            query.put(char(keys(i)),char(values{i}));
        end
    end

    projection = BasicDBObject();
    projection.put('_id',0);
    
    global collection;
    resultCursor = collection.find(query, projection);
end