% Add the downloaded JAR file to java path
javaaddpath('D:\School\Thesis\Matlabtest\mongo-java-driver-2.13.3.jar')
% import the library
import com.mongodb.*;

% To directly connect to a single MongoDB server (note that this will not auto-discover the primary even
% if it's a member of a replica set:
mongoClient = MongoClient();
% db object will be a connection to a MongoDB server for the specified database
db = mongoClient.getDB( 'mydb' );
% get a collection
global collection;
collection = db.getCollection('testCollection');
global writeconcern;
writeconcern = com.mongodb.WriteConcern(1);