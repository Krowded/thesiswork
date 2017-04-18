%Calculate the non-uniform scaling matrix between the eight vertices of
%slots1 and slots2
function S = scaleMatrixFromSlots(slots1, slots2, frontVectorSlots1, upVectorSlots1)
    z = frontVectorSlots1;
    y = upVectorSlots1;
    x = normalize(cross(y,z));

    %Lengths along each axis
    diffX1 = norm(slots1(1,:) - slots1(2,:));
    diffY1 = norm(slots1(2,:) - slots1(3,:));
    diffZ1 = norm(slots1(1,:) - slots1(5,:));
    
    diffX2 = norm(slots2(1,:) - slots2(2,:));
    diffY2 = norm(slots2(2,:) - slots2(3,:));
    diffZ2 = norm(slots2(1,:) - slots2(5,:));
    
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