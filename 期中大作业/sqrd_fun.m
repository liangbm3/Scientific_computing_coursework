function C = sqrd_fun(H, x)
%SQRD_FUN 此函数是对未排序QR算法的仿真实现
%   输入参数H：信道矩阵
%   输入参数x：接收到的信号
%   输出参数C：解调出来的信号矩阵
[row, col] = size(H);%计算信道矩阵H的大小
c = zeros(col, 1);  
C = zeros(col, 1);  
q = H;
r = zeros(col, col);
s = 1:col; % 用于记录排序的索引

% 进行QR 分解
for i2 = 1:col
    min_norm = norm(q(:, i2));  % 初始化最小范数
    k = i2;
    % 寻找最小范数列
    for j2 = i2:col
        if min_norm > norm(q(:, j2))
            min_norm = norm(q(:, j2));
            k = j2;
        end
    end
    % 交换列，更新 QR 分解矩阵
    q(:, [i2, k]) = q(:, [k, i2]);
    r(:, [i2, k]) = r(:, [k, i2]);
    s([i2, k]) = s([k, i2]);

    r(i2, i2) = norm(q(:, i2));
    q(:, i2) = q(:, i2) / r(i2, i2);

    % 更新 R 矩阵的剩余部分
    for l = i2+1:col
        r(i2, l) = q(:, i2)' * q(:, l);
        q(:, l) = q(:, l) - r(i2, l) * q(:, i2);
    end
end
y = q' * x;  % 计算中间变量 y
d = zeros(row, 1);
z = zeros(row, 1);

% 反向解调
for i = col:-1:1
    for j = i+1:col
        d(i) = d(i) + r(i, j) * c(j);  % 计算干扰项
    end
    
    z(i) = y(i) - d(i);  % 消除干扰项
    k = z(i) / r(i, i);%得到解调出来的原始信号
    if k < 0.5%对原始信号进行判决
        c(i) = 0;
    else
        c(i) = 1;
    end
end
% 根据排序结果将解调后的结果排序并返回
for i4 = 1:length(s)
    C(s(i4)) = c(i4);
end
end

