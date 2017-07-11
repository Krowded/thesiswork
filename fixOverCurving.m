function model = fixOverCurving(model, slot, direction)
    %Move slot to center
    m = getTranslationMatrixFromVector(-slot);
    model.vertices = applyTransformation(model.vertices, m);
    
    %Rotate around axis until all points are out of contention
    model.vertices = changeBasis(model.vertices, normalize(cross(model.upVector, model.frontVector)), model.upVector, model.frontVector);
    direction = changeBasis(direction,normalize(cross(model.upVector, model.frontVector)), model.upVector, model.frontVector);
    while 1
        a = -1;
        rotationMatrix = [cosd(a) -sind(a) 0 0;
                          sind(a) cosd(a) 0 0;
                          0 0 1 0
                          0 0 0 1];
        model.vertices = applyTransformation(model.vertices, rotationMatrix);
        
        curr = max(model.vertices*direction')
        if curr < 0% max(model.vertices*model.upVector') < 0
            break;
        end
    end
    model.vertices = revertBasis(model.vertices, normalize(cross(model,upVector, model.frontVector)), model.upVector, model.frontVector);

    %Move point back
    m = getTranslationMatrixFromVector(slot);
    model.vertices = applyTransformation(model.vertices, m);
end