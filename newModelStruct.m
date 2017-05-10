function modelStruct = newModelStruct(vertices, faces, faceNormals, frontVector, frontIndices, backIndices, slots, upVector, attributes)
    if nargin < 9
        attributes = string();
    end
    if nargin < 8
        upVector = [];
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
    modelStruct.frontIndices = frontIndices;
    modelStruct.backIndices = backIndices;
    modelStruct.slots = slots;
    modelStruct.attributes = attributes;
    modelStruct.frontCornerIndicesLeft = [];
    modelStruct.frontCornerIndicesRight = [];
    modelStruct.backCornerIndicesLeft = [];
    modelStruct.backCornerIndicesRight = [];
    modelStruct.filepaths = string.empty;
    
    modelStruct.adjustment = [0 0 0];
end