function M = fitToWall(newModelShape, wallBaseShape, normal)
    %Get contour
    newModelSlots = slotsFromModel(newModelShape, normal);

    %Wall slot placement
    wallSlots = slotsFromModel(wallBaseShape, normal);
    
    %Non-uniform scaling
    % S = scaleMatrixFromSlots(newModelSlots, wallSlots, normal, up);
    % newModelSlots = applyTransformation(newModelSlots, S);
    
    %Slot fitting
    [regParams, ~, ~] = absor(newModelSlots',wallSlots', 'doScale', 1, 'doTrans', 1);
    M = regParams.M;
    %M = M*S;
end