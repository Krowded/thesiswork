
% For extended documentation, see:
% http://docs.mongodb.org/ecosystem/tutorial/getting-started-with-java-driver/
%
% Add the downloaded JAR file to java path
javaaddpath('D:\School\Thesis\Matlabtest\mongo-java-driver-2.13.3.jar')
% import the library
import com.mongodb.*;

% To directly connect to a single MongoDB server (note that this will not auto-discover the primary even
% if it's a member of a replica set:
mongoClient = MongoClient();
% db object will be a connection to a MongoDB server for the specified database
db = mongoClient.getDB( 'mydb' );
% get the list of collections
colls = db.getCollectionNames();
% get a collection
coll = db.getCollection('testCollection');
% insert a document
% {
%    "name" : "MongoDB",
%    "type" : "database",
%    "count" : 1,
%    "info" : {
%                x : 203,
%                y : 102
%              }
%    "array" : [1 2 3 4 5 6 7 8 9 10]
% }

innerDoc = BasicDBObject();
innerDoc.put('x', 203);
innerDoc.put('y', 102);

doc = BasicDBObject();
doc.put('name', 'MongoDB');
doc.put('type', 'database');
doc.put('count', 1);
doc.put('info', innerDoc);
doc.put('array', [1 2 3 4 5 6 7 8 9 10]);

% FROM
% http://www.littlelostmanuals.com/2011/11/overview-of-basic-mongodb-java-write.html
%
% A write concern controls the behaviour of your write operation based upon 
% your provided write behaviour requirements.
% ------------------------------
% Default Write Concern 
% Lets imagine you want to persist a simple document with the property 'name' 
% with the value 'test' within in the collection 'customers'. Your first 
% version may look something like this:
%
% BasicDBObject dbObj = new BasicDBObject();   
% dbObj.put("name", "test");  
% DBCollection coll = getCollection("customers"); 
% coll.save(dbObj);
%
% The question you should be asking is where did that 'save' put the document? 
% The answer is it wrote it to the driver and returned immediately. By default
% the driver will perform a write behind to the mongodb server. This is very 
% powerful but remember the data may not be on the server when the method returns. 
% For example if you do a findOne(dbObj) immediately after the save it may 
% return null as the data may not have yet reached the server. 
% 
% Write Safe
% The Java Driver allows you to specify the write concern you require before 
% the save method returns. For example you may decided that instead of just 
% writing to the driver you would like to wait for the server to receive the
% write operations before returning.   
%  
% coll.save(dbObj,WriteConcern.SAFE); 
% 
% Now when save is executed it blocks until the primary node acknowledges 
% it received the write operation. If you do a findOne(dbObj) immediately 
% after the save, the primary will return the saved object as the data 
% reached the server in order to the save to  have returned.
wc = com.mongodb.WriteConcern(1); %Wait for acknowledgement, but don't wait 
                                   %for secondaries to replicate == SAFE
% insert the document into the database. If the database does not exist
% and/or if the collection does not exist, it is created at the first
% insertion. See mongoDB documentation for details.
%
% The insert method takes a collection of documents as input, so we must
% tell the server the writeconcern to control how to write in the DB
% As an alternative, we could use simply coll.save(doc) without
% writeconcern as the save method takes only one DBObject. This method is
% generally used to update a document (retrieve it, modify it and save it).
coll.insert(doc,wc);
% find the first document in a collection
myDoc = coll.findOne();
% log/parse the document into console as myDoc is a JSON object
% find keys
keys = myDoc.keySet.toArray; %---> java.lang.Object[]
for i=1:length(keys)
    keyStr = char(keys(i));    
    value = myDoc.get(keyStr);
    if isa(value, 'BasicDBObject')        
        space = [keyStr, ' --> '];
        innerKeys = value.keySet.toArray;
        for j=1:length(innerKeys)
            innerKeyStr = char(innerKeys(j));  
            innerValue = value.get(innerKeyStr);
            if isreal(innerValue)
                innerValueStr = num2str(innerValue);
            else
                innerValueStr = char(innerValue);
            end            
            disp([space, innerKeyStr, ' --> ', innerValueStr])
            space = '         ';
        end
    elseif isreal(value)
        valueStr = num2str(value);
    elseif isa(value, 'BasicDBList')
        % convert java.lang.Object[] to Matlab column vector
        array = cell2mat(value.toArray.cell);
        valueStr = num2str(array');
    else
        valueStr = char(value);
    end    
    disp([keyStr, ' --> ', valueStr])
end