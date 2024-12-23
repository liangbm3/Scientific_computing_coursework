function [Q, R] = myQR(A)
    [m, n] = size(A);
    Q = zeros(m, n);
    R = zeros(n);

    for j = 1:n
        v = A(:, j);
        for i = 1:j-1
            R(i, j) = Q(:, i)' * A(:, j);
            v = v - R(i, j) * Q(:, i);
        end
        R(j, j) = norm(v);
        Q(:, j) = v / R(j, j);
    end

    % Adjust signs of R and Q to match MATLAB's QR decomposition
    for i = 1:n
        if R(i, i) < 0
            R(i, i) = -R(i, i);
            Q(:, i) = -Q(:, i);
        end
    end
end
