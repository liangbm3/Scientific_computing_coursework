function ber = fer_test_fun2(Eb_No_dB,N_R,N_T,N_frame,func)
%VBLAST_TEST_FUN 该函数用来测试算法的误码率
%   输入参数Eb_No_dB：信噪比
%   输入参数N_R：接收天线数
%   输入参数N_R：发射天线数
%   输入参数N_frame：测试信号的帧数
%   输入参数func：函数句柄，使用解调算法的函数
%   输出参数fer:计算得到的误帧率
total_frame=N_frame;%总的比特数
error_frame=0;%初始化错误的比特数
for i=1:N_frame
    bit_stream_tx=randi([0,1],N_T,1);%发送的比特流
    c=bit_stream_tx;
    H=randn(N_R,N_T);
    Eb_No=10^(Eb_No_dB/10);   % 转换为绝对值
    bits_per_symbol=1;  % 假设采用二元调制映射， 每个符号含有1bit信息
    SNR=Eb_No*bits_per_symbol;      % 根据符号所含比特数 增大信噪比
    sigma=1/SNR;    % 假设发送符号能量平均为1，SNR定义为  符号能量/噪声能量， 可求出噪声能量（方差）
    v=sqrt(sigma)*randn(N_R,1);    % 生成满足当前信噪比条件的 高斯随机噪声样本
    x=H*c+v;%接收到的比特流
    info = functions(func);%对信号进行解调
    if strcmp(info.function, 'zf_fun')
        bit_stream_rx=func(H,x);
    else
        bit_stream_rx=func(H,x,sigma);
    end
if any(bit_stream_rx-bit_stream_tx)%累加错误的帧数
    error_frame=error_frame+1;
end
end
ber=error_frame/total_frame;%计算误码率
end
