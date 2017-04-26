function slotVertices = slotsFromModel(model)
    slotVertices = slotsFromModelVertices(model.vertices, model.frontNormal, model.upVector);
end