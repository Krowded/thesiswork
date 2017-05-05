%Adds inserts struct in mongodb as JSON
function [] = writeStructToDB(structToWrite)
    import com.mongodb.*;    
    global collection;
    global writeconcern;

    doc = BSONObjectFromStruct(structToWrite);

    collection.insert(doc, writeconcern);
end