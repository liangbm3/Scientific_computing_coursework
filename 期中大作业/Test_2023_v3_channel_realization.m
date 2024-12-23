clc
clear all
close all

% 系统常数
N_R=3;   % 接收天线数
N_T=4;   % 发送天线数


% Eb_No_dB_range=[0:4:16];    % 根据论文，定义 每bit与噪声方差的比值 单位为dB, 范围为0到16dB, 间隔4dB

Eb_No_dB=0;    % 根据论文，定义 每bit与噪声方差的比值 单位为dB
Eb_No=10^(Eb_No_dB/10);   % 转换为绝对值

bits_per_symbol=1;  % 假设采用二元调制映射， 每个符号含有1bit信息
SNR=Eb_No*bits_per_symbol;      % 根据符号所含比特数 增大信噪比



for channel_realization=1:100


N_frame=100;

bit_stream_tx=randi([0,1],N_T,N_frame);   % 产生 0，1比特流信息序列（向量）

c=round(bit_stream_tx-0.5);   % 产生 {1，-1}  BPSK星座图符号  （数字调制）



   H=randn(N_R,N_T);   % 产生实数信道矩阵， 元素为零均值，单位方差的高斯随机变量



sigma=1/SNR;    % 假设发送符号能量平均为1，SNR定义为  符号能量/噪声能量， 可求出噪声能量（方差）

v=sqrt(sigma)*randn(N_R,N_frame);     % 生成满足当前信噪比条件的 高斯随机噪声样本



%  v=0;
x=H*c+v;     % 信号经过空口信道到达接收机，接收信号向量为x


W=inv(H'*H)*H';  
x_hat=W*x;         % 直接求伪逆矩阵，作用于接收信号x.  此处需避免求逆，而是采用解正规方程的方式来求x_hat

 %H'H*x_hat=H'*x;   % 采用解正规方程的方式来求x_hat,自己编写高斯消元，LU分解或Cholesky乔利斯基分解
 %来解出x_hat;

 
% 以下为星座图（复数平面的欧式最小距离判决，由于发送的实数信号，简化为实数轴上的汉明最小距离判决） 

for iFrame=1:N_frame

for ii=1:N_T
    distance1=abs(x_hat(ii,iFrame)-1);
    distance2=abs(x_hat(ii,iFrame)+1);
    if distance1<distance2
         x_bar(ii,iFrame)=1;
    else 
        x_bar(ii,iFrame)=-1;
    end 
end                %此过程较为直观，但是效率不高，可思考如何更高效实现  提示：避免用循环

end 

bit_stream_rx=min(x_bar+1,1);

error_bit_vector=bit_stream_rx-bit_stream_tx;
error_pos=find(error_bit_vector);

error_bit_number(channel_realization)=length(error_pos);

end 
BER=sum(error_bit_number)/(length(bit_stream_tx(:))*channel_realization);
tt=1;



