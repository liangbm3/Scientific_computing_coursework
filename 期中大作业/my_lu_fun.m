function [L, U] = my_lu_fun(A)
    [m, n] = size(A);
    if m ~= n
        error('A 不是一个方阵');
    end
    
    L = eye(n); % 初始化 L 为单位下三角矩阵
    U = A;      % 初始化 U 为 A 的副本

    for k = 1:n-1
        % 部分选主元
        [~, maxRow] = max(abs(U(k:n, k))); % 找出列 k 下的绝对值最大元素所在的行
        maxRow = maxRow + k - 1; % 调整行号
        if maxRow ~= k
            % 交换 U 的行
            temp = U(k, :);
            U(k, :) = U(maxRow, :);
            U(maxRow, :) = temp;

            % 交换 L 的行（从第二行开始，且只需交换 k 列之前的元素）
            temp = L(k, 1:k-1);
            L(k, 1:k-1) = L(maxRow, 1:k-1);
            L(maxRow, 1:k-1) = temp;
        end

        for i = k+1:n
            factor = U(i, k) / U(k, k);
            L(i, k) = factor;
            U(i, k:n) = U(i, k:n) - factor * U(k, k:n);
        end
    end
end
