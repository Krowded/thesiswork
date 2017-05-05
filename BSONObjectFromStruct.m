function bsonObject = BSONObjectFromStruct(structToConvert)
    import com.mongodb.*;
    bsonObject = BasicDBObject();
    fields = fieldnames(structToConvert);
    
    for i = 1:length(fields)
        fieldname = fields{i};
        content = structToConvert.(fieldname);

        if isstring(content)
            modifiedContent = char(content);
        elseif isstruct(content)
            numberOfStructs = length(content);
            modifiedContent = javaArray('com.mongodb.BasicDBObject', numberOfStructs);
            for j = 1:numberOfStructs
                modifiedContent(j) = BSONObjectFromStruct(content(j));
            end
        else
            modifiedContent = content;
        end
        
        if isempty(modifiedContent), continue, end
        
        bsonObject.put(fieldname, modifiedContent);
    end
end