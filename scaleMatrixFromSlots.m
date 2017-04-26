%Calculate the non-uniform scaling matrix between the eight vertices of
%slots1 and slots2
function S = scaleMatrixFromSlots(originalSlots, targetSlots, frontVectorSlots1, upVectorSlots1)
    z = frontVectorSlots1;
    y = upVectorSlots1;
    x = normalize(cross(y,z));

    %Lengths along each axis
    diffX1 = norm(originalSlots(1,:) - originalSlots(2,:));
    diffY1 = norm(originalSlots(2,:) - originalSlots(3,:));
    diffZ1 = norm(originalSlots(1,:) - originalSlots(5,:));
    
    diffX2 = norm(targetSlots(1,:) - targetSlots(2,:));
    diffY2 = norm(targetSlots(2,:) - targetSlots(3,:));
    diffZ2 = norm(targetSlots(1,:) - targetSlots(5,:));
    
    %Proportional difference
    scaleZ = diffX2/diffX1; %Z and X are switched? Look into it
    scaleY = diffY2/diffY1;
    scaleX = diffZ2/diffZ1;
    
    %Non-uniform scaling matrix
    S = scaleX*x';
    S = [S scaleY*y'];
    S = [S scaleZ*z'];
    S = [S; 0, 0, 0];
    S = [S [0;0;0;1]];
end