% 系统常数
N_R=4;   % 接收天线数
N_T=4;   % 发送天线数
N_frame=10;
bit_stream_tx=randi([0,1],N_T,N_frame)
c=round(bit_stream_tx-0.5);
H=randn(N_R,N_T);
v=0;
x_bar=zeros(1,N_frame);
bit_stream_rx=zeros(N_T,N_frame);
x=H*c+v;
for i=1:N_T
    size_H=size(H)
    G=inv(H'*H)*H';
    min_norm=norm(G(1,:));
    min_list=1;
    for j=2:size_H(2)
        temp=norm(G(j,:));
        if temp<min_norm
            min_norm=temp;
            min_list=j;
        end
    end
    
    g=G(min_list,:);
    x_hat=g*x;
    for iFrame=1:N_frame
        distance1=abs(x_hat(iFrame)-1);
        distance2=abs(x_hat(iFrame)+1);
        if distance1<distance2
            x_bar(iFrame)=1;
        else 
            x_bar(iFrame)=-1;
        end 
    end
x=x-H(:,min_list)*x_bar;
bit_stream_rx(min_list,:)=min(x_bar+1,1)
H(:,[min_list])=[]
min_norm
end
bit_stream_rx;
error_bit_vector=bit_stream_rx-bit_stream_tx;
error_num=length(find(error_bit_vector));
error_rat=error_num/(N_frame*N_T)