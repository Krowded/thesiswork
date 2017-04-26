%Returns the transformation matrix that minimizes the geometric error
%between slots and targetSlots
%The scaling variable can be either 'uniform' or 'non-uniform' and decides
%in which way the matrix will scale. The default is 'uniform'.
function M = matchSlots(slots, targetSlots, scaling, normal, up)
    if nargin < 4
        scaling = 'uniform';
        normal = [];
        up = [];
    end
    
    if strcmp(scaling, 'uniform')
        %Slot fitting
        [regParams, ~, ~] = absor(slots', targetSlots', 'doScale', 1, 'doTrans', 1);
        M = regParams.M;
    elseif strcmp(scaling, 'non-uniform')
        %Slot fitting
        [regParams, ~, ~] = absor(slots', targetSlots', 'doScale', 0, 'doTrans', 1);
        M = regParams.M;
        slots = applyTransformation(slots, M);
        %Non-uniform scaling
        S = scaleMatrixFromSlots(slots, targetSlots, normal, up);
        slots = applyTransformation(slots,S);
        M = S*M;
        %adjust again...
        [regParams, ~, ~] = absor(slots', targetSlots', 'doScale', 0, 'doTrans', 1);
        M = regParams.M*M;
    else
        error('Scaling can only be uniform or non-uniform');
    end    
end