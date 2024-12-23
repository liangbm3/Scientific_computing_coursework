function ber = ber_test_svd_fun(Eb_No_dB,N_R,N_T,N_frame,func)
%VBLAST_TEST_FUN 该函数用来测试算法的误码率
%   输入参数Eb_No_dB：信噪比
%   输入参数N_R：接收天线数
%   输入参数N_R：发射天线数
%   输入参数N_frame：测试信号的帧数
%   输入参数func：函数句柄，使用解调算法的函数
%   输出参数ber:计算得到的误码率
total_bit=N_T*N_frame;%总的比特数
error_bit=0;%初始化错误的比特数
for i=1:N_frame
    H=randn(N_R,N_T);
    [~,~,V_]=svd(H);
    bit_stream_tx=randi([0,1],N_T,1);%发送的比特流
    c=V_*bit_stream_tx;%左乘V矩阵
    Eb_No=10^(Eb_No_dB/10);   % 转换为绝对值
    bits_per_symbol=1;  % 假设采用二元调制映射， 每个符号含有1bit信息
    SNR=Eb_No*bits_per_symbol;      % 根据符号所含比特数 增大信噪比
    sigma=1/SNR;    % 假设发送符号能量平均为1，SNR定义为  符号能量/噪声能量， 可求出噪声能量（方差）
    v=sqrt(sigma)*randn(N_R,1);    % 生成满足当前信噪比条件的 高斯随机噪声样本
    x=H*c+v;%接收到的比特流
    bit_stream_rx=func(H,x);
    error_bit_vector=bit_stream_rx-bit_stream_tx;%累加错误的比特数
    error_bit=error_bit+length(find(error_bit_vector));
end
ber=error_bit/total_bit;%计算误码率
end
