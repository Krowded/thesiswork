%Returns the transformation matrix that minimizes the geometric error
%between slots and targetSlots
%If there are a different number of slots in in slots and targetSlots, the
%only the lower indexed slots will be used
%The scaling variable can be either 'uniform' or 'non-uniform' and decides
%in which way the matrix will scale. The default is 'uniform'.
function M = matchSlots(slots, targetSlots, scalingType, normal, up)
    if nargin < 3
        scalingType = 'uniform';
        normal = [];
        up = [];
    end
    
    %Use the one with the smallest number
    numSlots = size(slots,1);
    numTargetSlots = size(targetSlots,1);
    if numSlots > numTargetSlots
        slots = slots(1:numTargetSlots,:);
    elseif numSlots < numTargetSlots
        targetSlots = targetSlots(1:numSlots,:);
    end
    
    switch scalingType
        case 'uniform'
            %Slot fitting, uniform scaling
            [regParams, ~, ~] = absor(slots', targetSlots', 'doScale', 1, 'doTrans', 1);
            M = regParams.M;
        case 'non-uniform'
            %Slot fitting, uniform scaling
            [regParams, ~, ~] = absor(slots', targetSlots', 'doScale', 1, 'doTrans', 1);
            M = regParams.M;
            slots = applyTransformation(slots, M);
            %Non-uniform scaling
            S = scaleMatrixFromSlots(slots, targetSlots, normal, up);
            slots = applyTransformation(slots,S);
            M = S*M;
            %Final adjustment without scaling
            [regParams, ~, ~] = absor(slots', targetSlots', 'doScale', 0, 'doTrans', 1);
            M = regParams.M*M;
        otherwise
            error('Scaling can only be uniform or non-uniform');
    end    
end