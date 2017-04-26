%Returns the transformation matrix M that minimizes the error between
%slots, as well as the original model with its vertices adjusted by M.
%Scaling works as in matchSlots.
function [adjustedModel, M] = matchModels(originalModel, targetModel, scaling)
    if nargin < 3
        %Do nothing
        scaling = 'uniform';
    end

    M = matchSlots(originalModel.slots, targetModel.slots, scaling, targetModel.frontNormal, targetModel.upVector);
    originalModel.vertices = applyTransformation(originalModel.vertices, M);
    originalModel.slots = applyTransformation(originalModel.slots, M);
    originalModel.frontNormal = targetModel.frontNormal;
    originalModel.upVector = targetModel.upVector;
    adjustedModel = originalModel;
end