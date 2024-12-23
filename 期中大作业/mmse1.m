% 系统常数
N_R=4;   % 接收天线数
N_T=3;   % 发送天线数
N_frame=1000000;%比特流长度
bit_stream_tx=randi([0,1],N_T,N_frame);%发送的比特流
c=bit_stream_tx;
H=randn(N_R,N_T);
Eb_No_dB=20;    % 根据论文，定义 每bit与噪声方差的比值 单位为dB
Eb_No=10^(Eb_No_dB/10);   % 转换为绝对值
bits_per_symbol=1;  % 假设采用二元调制映射， 每个符号含有1bit信息
SNR=Eb_No*bits_per_symbol;      % 根据符号所含比特数 增大信噪比
sigma=1/SNR;    % 假设发送符号能量平均为1，SNR定义为  符号能量/噪声能量， 可求出噪声能量（方差）
v=sqrt(sigma)*randn(N_R,N_frame);        % 生成满足当前信噪比条件的 高斯随机噪声样本
x=H*c+v;
bit_stream_rx=zeros(N_T,N_frame);
for i=1:N_frame
    bit_stream_rx(:,i)=mmse(H,x(:,i),sqrt(sigma));
end
error_bit_vector=bit_stream_rx-bit_stream_tx;
error_num=length(find(error_bit_vector));
error_rat=error_num/(N_frame*N_T)
function c=mmse(H,x,n)
    [row,col]=size(H);
    I=n*eye(col);
    G=inv(H'*H+I)*H';
    c=G*x;
    [row2,col2]=size(c);
    for i=1:row2
        for j=1:col2
            if c(i,j)<0.5
                c(i,j)=0;
            else
                c(i,j)=1;
            end
        end
    end
end