%Calculate the non-uniform scaling matrix between the eight vertices of
%slots1 and slots2
function S = scaleMatrixFromSlots(originalSlots, targetSlots, frontVectorSlots1, upVectorSlots1)
    z = frontVectorSlots1;
    y = upVectorSlots1;
    x = normalize(cross(y,z));

    %Lengths along each axis
    tempX = originalSlots*x';
    diffX1 = max(tempX) - min(tempX);
    tempY = originalSlots*y';
    diffY1 = max(tempY) - min(tempY);
    tempZ = originalSlots*z';
    diffZ1 = max(tempZ) - min(tempZ);
    
    tempX = targetSlots*x';
    diffX2 = max(tempX) - min(tempX);
    tempY = targetSlots*y';
    diffY2 = max(tempY) - min(tempY);
    tempZ = targetSlots*z';
    diffZ2 = max(tempZ) - min(tempZ);

    %Proportional difference
    scaleX = diffX2/diffX1; %Z and X are switched? Look into it
    scaleY = diffY2/diffY1;
    scaleZ = diffZ2/diffZ1;
    
    %If any direction NaN or Inf or zero we assume missing info and return no scaling
    if isnan(scaleX) || isinf(scaleX) || scaleX == 0; scaleX = 1; end
    if isnan(scaleY) || isinf(scaleY) || scaleY == 0; scaleY = 1; end
    if isnan(scaleZ) || isinf(scaleZ) || scaleZ == 0; scaleZ = 1; end
    
    %Non-uniform scaling matrix
    S = scaleX*x';
    S = [S scaleY*y'];
    S = [S scaleZ*z'];
    S = [S; 0, 0, 0];
    S = [S [0;0;0;1]];
end