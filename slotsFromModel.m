function slotVertices = slotsFromModel(model)
    slotVertices = slotsFromModelVertices(model.vertices, model.frontVector, model.upVector);
end