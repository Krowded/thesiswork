function slotVertices = slotsFromModel(model)
%     slotVertices = slotsFromModelVertices(model.vertices, model.frontVector, model.upVector);
    slotVertices = boundingBoxCornerVertices(model.vertices, model.frontVector, model.upVector);

    if isfield(model, 'slotType')
        if strcmp(model.slotType, 'surface')
            slotVertices = slotVertices(1:4,:);
        end
    end
end