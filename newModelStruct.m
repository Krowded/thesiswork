function modelStruct = newModelStruct(vertices, faces, faceNormals, normal, frontIndices, backIndices, slots, connections, upVector, attributes)
    if nargin < 10
        attributes = string();
    end
    if nargin < 9
        upVector = [0, 1 ,0];
    end
    if nargin < 8
        connections  = strings([0,0]);
    end
    if nargin < 7
        slots = [];
    end
    if nargin < 6
        backIndices = [];
    end
    if nargin < 5
        frontIndices = [];
    end
    if nargin < 4
        normal = [];
    end
    if nargin < 3
        faceNormals = [];
    end
    if nargin < 2
        faces = [];
    end
    if nargin < 1
        vertices = [];
    end
    
    modelStruct.vertices = vertices;
    modelStruct.faces = faces;
    modelStruct.faceNormals = faceNormals;
    modelStruct.frontNormal = normal;
    modelStruct.frontIndices = frontIndices;
    modelStruct.backIndices = backIndices;
    modelStruct.slots = slots;
    modelStruct.connections = connections;
    modelStruct.upVector = upVector;
    modelStruct.attributes = attributes;
    modelStruct.cornerIndicesLeft = [];
    modelStruct.cornerIndicesRight = [];
end