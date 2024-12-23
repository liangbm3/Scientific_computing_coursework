% 系统常数
N_R=4;   % 接收天线数
N_T=3;   % 发送天线数
N_frame=10;%比特流长度
bit_stream_tx=randi([0,1],N_T,N_frame);%发送的比特流
c=bit_stream_tx;
H=randn(N_R,N_T);
Eb_No_dB=0;    % 根据论文，定义 每bit与噪声方差的比值 单位为dB
Eb_No=10^(Eb_No_dB/10);   % 转换为绝对值
bits_per_symbol=1;  % 假设采用二元调制映射， 每个符号含有1bit信息
SNR=Eb_No*bits_per_symbol;      % 根据符号所含比特数 增大信噪比
sigma=1/SNR;    % 假设发送符号能量平均为1，SNR定义为  符号能量/噪声能量， 可求出噪声能量（方差）
v=0;     % 生成满足当前信噪比条件的 高斯随机噪声样本
x=H*c+v;
for i=1:N_frame
    bit_stream_rx(:,i)=SORD(H,x)
end
error_bit_vector=bit_stream_rx-bit_stream_tx;
error_num=length(find(error_bit_vector));
error_rat=error_num/(N_frame*N_T)
function C = SORD(H, x)
    [row, col] = size(H);
    c = zeros(col, 1);  % 初始化解码后的结果向量
    C = zeros(col, 1);  % 初始化最终输出的解调结果向量

    q = H;
    r = zeros(col, col);
    s = 1:col; % 生成等差数列，用于记录列索引的排序

    % QR 分解
    for i2 = 1:col
        min_norm = norm(q(:, i2));  % 初始化最小范数
        k = i2;
        % 寻找最小范数列
        for j2 = i2:col-1
            if min_norm > norm(q(:, j2))
                min_norm = norm(q(:, j2));
                k = j2;
        end

        % 交换列，更新 QR 分解矩阵
        q(:, [i2, k]) = q(:, [k, i2]);
        r(:, [i2, k]) = r(:, [k, i2]);
        s([i2, k]) = s([k, i2]);

        r(i2, i2) = norm(q(:, i2));
        q(:, i2) = q(:, i2) / r(i2, i2);

        % 更新 R 矩阵的剩余部分
        for l = i2:col-1
            r(i2, l) = q(:, i2)' * q(:, l);
            q(:, l) = q(:, l) - r(i2, l) * q(:, i2);
        end
    end

    y = q' * x;  % 计算中间变量 y
    d = zeros(col, 1);
    z = zeros(col, 1);

    % 反向解调
    for i = col:-1:1
        for j = i+1:col
            d(i) = d(i) + r(i, j) * c(j);  % 计算干扰
        end
        
        z(i) = y(i) - d(i);  % 消除干扰后的值
        k = z(i) / r(i, i);
        if k < 0.5
            c(i) = 0;
        else
            c(i) = 1;
        end
    end

    % 根据排序结果将解调后的结果排序并返回
    for i4 = 1:length(s)
        C(s(i4)+1) = c(i4);
    end
end
