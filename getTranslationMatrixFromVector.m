function translationMatrix = getTranslationMatrixFromVector(translationVector)
    translationMatrix = diag([1,1,1]);
    translationMatrix(:,4) = translationVector;
    translationMatrix(4,:) = [0, 0, 0, 1];
end