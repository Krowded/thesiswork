function modelStruct = newModelStruct(vertices, faces, faceNormals, frontVector, upVector, slots, attributes)
    if nargin < 7
        attributes = string();
    end
    if nargin < 6
        slots = [];
    end
    if nargin < 5
        upVector = [];
    end
    if nargin < 4
        frontVector = [];
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
    modelStruct.frontVector = frontVector;
    modelStruct.upVector = upVector;
    modelStruct.sideVector = [];
    modelStruct.slots = slots;
    modelStruct.attributes = attributes;
    modelStruct.filepaths = string.empty;
end