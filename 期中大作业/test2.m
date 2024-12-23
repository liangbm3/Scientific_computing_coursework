% 系统常数
N_R=4;   % 接收天线数
N_T=3;   % 发送天线数
N_frame=10000000;
bit_stream_tx=randi([0,1],N_T,N_frame);
c=round(bit_stream_tx-0.5);
H=randn(N_R,N_T);
v=0;
x=H*c+v;
W=inv(H'*H)*H';
x_hat=W*x;
for iFrame=1:N_frame
for ii=1:N_T
    distance1=abs(x_hat(ii,iFrame)-1);
    distance2=abs(x_hat(ii,iFrame)+1);
    if distance1<distance2
         x_bar(ii,iFrame)=1;
    else 
        x_bar(ii,iFrame)=-1;
    end 
end
end
bit_stream_rx=min(x_bar+1,1);
error_bit_vector=bit_stream_rx-bit_stream_tx;
error_num=length(find(error_bit_vector));
error_rat=error_num/(N_frame*N_T)