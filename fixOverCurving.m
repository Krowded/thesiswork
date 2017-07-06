function model = fixOverCurving(model, slot)
    %Move slot to center
    m = getTranslationMatrixFromVector(-slot);
    model.vertices = applyTransformation(model.vertices, m);
    
    %Rotate around axis until all points are out of contention
    model.vertices = changeBasis(model.vertices, normalize(cross(model,upVector, model.frontVector)), model.upVector, model.frontVector);
    while 1
        a = -1;
        rotationMatrix = [cos(a) -sin(a) 0 0;
                          sin(a) cos(a) 0 0;
                          0 0 1 0
                          0 0 0 1];
        model.vertices = applyTransformation(model.vertices, rotationMatrix);
        
        if max(model.vertices*model.upVector') < 0
            break;
        end
    end
    model.vertices = revertBasis(model.vertices, normalize(cross(model,upVector, model.frontVector)), model.upVector, model.frontVector);

    %Move point back
    m = getTranslationMatrixFromVector(slot);
    model.vertices = applyTransformation(model.vertices, m);
end