%Returns the translation vector for moving all vertices above groundLevel
function translation = constrainAboveGround(vertices, upVector, groundLevel)
    lowestPoint = min(vertices*upVector');
    if lowestPoint < groundLevel
        translation = upVector*(groundLevel - lowestPoint);
    else
        translation = [0, 0, 0];
    end
end