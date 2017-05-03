%Adds inserts struct in mongodb as JSON
function [] = writeStructToDB(structToWrite)
    import com.mongodb.*;    
    global collection;
    global writeconcern;

    fields = fieldnames(structToWrite);
    doc = BasicDBObject();
    
    for i = 1:length(fields)
        doc.put(fields{i}, structToWrite.(fields{i}));
    end

    collection.insert(doc, writeconcern);
end