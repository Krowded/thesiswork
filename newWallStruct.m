function wallStruct = newWallStruct(vertices, faces, faceNormals, normal, frontIndices, backIndices, slots, upVector, attributes)
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
    
    wallStruct.vertices = vertices;
    wallStruct.faces = faces;
    wallStruct.faceNormals = faceNormals;
    wallStruct.frontNormal = normal;
    wallStruct.frontIndices = frontIndices;
    wallStruct.backIndices = backIndices;
    wallStruct.slots = slots;
    wallStruct.upVector = upVector;
    wallStruct.attributes = attributes;
    wallStruct.cornerIndicesLeft = [];
    wallStruct.cornerIndicesRight = [];
    wallStruct.filepath = '';
end