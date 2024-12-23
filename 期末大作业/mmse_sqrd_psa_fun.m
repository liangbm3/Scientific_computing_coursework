function C = mmse_sqrd_psa_fun(H,x,n)
%MMSE_SQRD_FUN 该函数实现MMSE-QRD-PSA算法
%   输入参数H：信道矩阵
%   输入参数x：接收到的信号
%   输入参数n：噪声的标准差
%   输出参数C：解调出来的信号矩阵
[row1,col1]=size(H);
I=n*eye(col1);
H=[H;I];%对信道矩阵进行扩展
x=[x;zeros(col1,1)];%对接收的信号进行处理
[row,col]=size(H);
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
    q(1:row1+i2-1, [i2, k]) = q(1:row1+i2-1, [k, i2]);
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
Q1=q(1:row-col,1:col);
Q2=q(row-col1+1:end,1:col);
%psa部分
kmin=col;
p=1:col;
for i=col:-1:2
    error=zeros(i,1);
    for l=1:i
        error(l)=vecnorm(Q2(l,1:i),2,2)^2;
    end
    [~,ki]=min(error);
    kmin=min(kmin,ki);
    if ki<i
        Q2([i ki],:)=Q2([ki i],:);
        p([i ki])=p([ki i]);
    end
    if kmin<i
        a=Q2(i,kmin:i);
        e=[zeros(1,length(a)-1),1];
        u=(a-norm(a)*e)/norm(a-norm(a)*e);
        w=(u*a')/(a*u');
        re=eye(length(a))-(1+w)*(u')*u;
        Q2(1:i,kmin:i)=Q2(1:i,kmin:i)*re;
        Q1(:,kmin:i)=Q1(:,kmin:i)*re;
    end
    % if kmin<i
    %     a=Q2(i,kmin:i);
    %     length_a=length(a);
    %     norm_a=sqrt(a*a');
    %     e_n=ones(1,length_a);
    %     e_n(1)=0;
    %     u=(a-norm_a*e_n)/norm(a-norm_a*e_n);
    %     w=u*a'/(a*u');
    %     HR=eye(length_a)-(1+w)*u'*u;
    %     Q2(1:i,kmin:i)=Q2(1:i,kmin:i)*HR;
    %     Q1(:,kmin:i)=Q1(:,kmin:i)*HR;
    % end
end

R=n*inv(Q2);
y = q' * x;  % 计算中间变量 y
d = zeros(row, 1);
z = zeros(row, 1);
% 反向解调
for i = col:-1:1
    for j = i+1:col
        d(i) = d(i) + R(i, j) * c(j);  % 计算干扰项
    end
    
    z(i) = y(i) - d(i);  % 消除干扰项
    k = z(i) / R(i, i);%得到解调出来的原始信号
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