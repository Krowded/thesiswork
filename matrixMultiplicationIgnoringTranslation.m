function M = matrixMultiplicationIgnoringTranslation(M1, M2, T)
    M = zeros(4,4);
    M(1:3,1:3) = M1(1:3,1:3)*M2(1:3,1:3);
    M(:,4) = T(:,4);
    M(4,:) = T(4,:);
end