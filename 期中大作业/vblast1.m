% 系统常数
N_R=4;   % 接收天线数
N_T=3;   % 发送天线数
N_frame=1000000;%比特流长度
bit_stream_tx=randi([0,1],N_T,N_frame);%发送的比特流
c=round(bit_stream_tx-0.5);
H=randn(N_R,N_T);
Eb_No_dB=0;    % 根据论文，定义 每bit与噪声方差的比值 单位为dB
Eb_No=10^(Eb_No_dB/10);   % 转换为绝对值
bits_per_symbol=1;  % 假设采用二元调制映射， 每个符号含有1bit信息
SNR=Eb_No*bits_per_symbol;      % 根据符号所含比特数 增大信噪比
sigma=1/SNR;    % 假设发送符号能量平均为1，SNR定义为  符号能量/噪声能量， 可求出噪声能量（方差）
v=sqrt(sigma)*randn(N_R,N_frame);     % 生成满足当前信噪比条件的 高斯随机噪声样本
x=H*c+v;
bit_stream_rx=zeros(N_T,N_frame);
bar=zeros(1,N_frame);
index=1:N_frame;
for i=1:N_T
    size_H=size(H);
    G=pinv(H);
    k=1;
    v=norm(G(1,:));
    for j=1:size_H(2)
        temp=norm(G(j,:));
        if temp<v
            v=temp;
            k=j;
        end
    end
    hat=G(k,:)*x;
    for iFrame=1:N_frame
        distance1=abs(hat(iFrame)-1);
        distance2=abs(hat(iFrame)+1);
        if distance1<distance2
            bar(iFrame)=1;
        else 
            bar(iFrame)=-1;
        end 
    end
    bit_stream_rx(index(k),:)=min(bar+1,1);
    index(k)=[];
    x=x-H(:,k)*hat;
    H(:,k)=[];
end
bit_stream_tx;
bit_stream_rx;
error_bit_vector=bit_stream_rx-bit_stream_tx;
error_num=length(find(error_bit_vector));
error_rat=error_num/(N_frame*N_T)