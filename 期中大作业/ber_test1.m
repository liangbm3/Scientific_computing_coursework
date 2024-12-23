N_R=12;   % 接收天线数
N_T=8;   % 发送天线数
times=10000;
x=0:1:20;
y1 = zeros(21, 1);
% y2 = zeros(21, 1);
% y3 = zeros(21, 1);
% parfor i = 0:20
%     y1(i + 1) = fer_test_fun(i, N_R, N_T, times, @zf_fun);
%     y2(i + 1) = fer_test_fun(i, N_R, N_T, times, @ml_fun);
%     % y3(i + 1) = ber_test_fun(i, N_R, N_T, times, @sqrd_fun);
% end
tic
for i=1:20
    y1(i + 1) = ber_test_fun2(i, N_R, N_T, times, @mmse_fun);
end
toc
% parfor i = 0:20
%     y1(i + 1) = fer_test_fun(i, N_R, N_T, times, @vblast_fun);
%     y2(i + 1) = fer_test_fun(i, N_R, N_T, times, @qr_fun);
%     y3(i + 1) = fer_test_fun(i, N_R, N_T, times, @sqrd_fun);
% end
% for i = 0:20
%     fprintf("V-blast信噪比：%f,误码率:%e\n", i, y1(i + 1) * 100);
%     fprintf("Unsorted QRD信噪比：%f,误码率:%e\n", i, y2(i + 1) * 100);
%     fprintf("Sorted QRD信噪比：%f,误码率:%e\n", i, y3(i + 1) * 100);
% end
% 
semilogy(x,y1,"r-*")
% ylabel("BER")
% xlabel("$\frac{E_{b}}{N_{0}}$ in dB","Interpreter","latex")
% legend('ZF解调复数信号','ZF解调实数信号','Location','best')
% % title("信号在不同算法和在不同信噪比下的误码率")
% t=toc;
% fprintf("发射天线数为%d,接收天线数为：%d,数据帧数为%f,仿真完成的时间为：%f秒\n",N_T,times,N_R,t)