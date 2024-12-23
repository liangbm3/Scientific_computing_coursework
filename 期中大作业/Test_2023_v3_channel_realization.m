clc
clear all
close all

% ϵͳ����
N_R=3;   % ����������
N_T=4;   % ����������


% Eb_No_dB_range=[0:4:16];    % �������ģ����� ÿbit����������ı�ֵ ��λΪdB, ��ΧΪ0��16dB, ���4dB

Eb_No_dB=0;    % �������ģ����� ÿbit����������ı�ֵ ��λΪdB
Eb_No=10^(Eb_No_dB/10);   % ת��Ϊ����ֵ

bits_per_symbol=1;  % ������ö�Ԫ����ӳ�䣬 ÿ�����ź���1bit��Ϣ
SNR=Eb_No*bits_per_symbol;      % ���ݷ������������� ���������



for channel_realization=1:100


N_frame=100;

bit_stream_tx=randi([0,1],N_T,N_frame);   % ���� 0��1��������Ϣ���У�������

c=round(bit_stream_tx-0.5);   % ���� {1��-1}  BPSK����ͼ����  �����ֵ��ƣ�



   H=randn(N_R,N_T);   % ����ʵ���ŵ����� Ԫ��Ϊ���ֵ����λ����ĸ�˹�������



sigma=1/SNR;    % ���跢�ͷ�������ƽ��Ϊ1��SNR����Ϊ  ��������/���������� ������������������

v=sqrt(sigma)*randn(N_R,N_frame);     % �������㵱ǰ����������� ��˹�����������



%  v=0;
x=H*c+v;     % �źž����տ��ŵ�������ջ��������ź�����Ϊx


W=inv(H'*H)*H';  
x_hat=W*x;         % ֱ����α����������ڽ����ź�x.  �˴���������棬���ǲ��ý����淽�̵ķ�ʽ����x_hat

 %H'H*x_hat=H'*x;   % ���ý����淽�̵ķ�ʽ����x_hat,�Լ���д��˹��Ԫ��LU�ֽ��Cholesky����˹���ֽ�
 %�����x_hat;

 
% ����Ϊ����ͼ������ƽ���ŷʽ��С�����о������ڷ��͵�ʵ���źţ���Ϊʵ�����ϵĺ�����С�����о��� 

for iFrame=1:N_frame

for ii=1:N_T
    distance1=abs(x_hat(ii,iFrame)-1);
    distance2=abs(x_hat(ii,iFrame)+1);
    if distance1<distance2
         x_bar(ii,iFrame)=1;
    else 
        x_bar(ii,iFrame)=-1;
    end 
end                %�˹��̽�Ϊֱ�ۣ�����Ч�ʲ��ߣ���˼����θ���Чʵ��  ��ʾ��������ѭ��

end 

bit_stream_rx=min(x_bar+1,1);

error_bit_vector=bit_stream_rx-bit_stream_tx;
error_pos=find(error_bit_vector);

error_bit_number(channel_realization)=length(error_pos);

end 
BER=sum(error_bit_number)/(length(bit_stream_tx(:))*channel_realization);
tt=1;



