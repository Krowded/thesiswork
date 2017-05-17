function bsonObject = BSONObjectFromStruct(structToConvert)
    import com.mongodb.*;
    bsonObject = BasicDBObject();
    fields = fieldnames(structToConvert);
    
    for i = 1:length(fields)
        fieldname = fields{i};
        content = structToConvert.(fieldname);

        if isstruct(content)
            numberOfStructs = length(content);
            modifiedContent = javaArray('com.mongodb.BasicDBObject', numberOfStructs);
            for j = 1:numberOfStructs
                modifiedContent(j) = BSONObjectFromStruct(content(j));
            end
        elseif length(content) > 1
            modifiedContent = BasicDBList;
            for j = 1:length(content)
                if isstring(content(j))
                    temp = char(content(j));
                else
                    temp = content(j);
                end
                modifiedContent.put(num2str(j-1), temp);
            end
        else 
            if isstring(content)
                modifiedContent = char(content);
            else
                modifiedContent = content;
            end
        end
        
        if isempty(modifiedContent), continue, end
        
        bsonObject.put(fieldname, modifiedContent);
    end
end