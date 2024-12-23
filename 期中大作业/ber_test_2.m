N_R=8;   % 接收天线数
N_T=6;   % 发送天线数
times=1000000;
x=0:1:20;
y1 = zeros(21, 1);
y2 = zeros(21, 1);
y3 = zeros(21, 1);
y4 = zeros(21, 1);
parfor i = 0:20
    y1(i + 1) = fer_test_fun2(i, N_R, N_T, times, @zf_fun);
    y2(i + 1) = fer_test_fun2(i, N_R, N_T, times, @mmse_fun);
    y3(i + 1) = fer_test_fun2(i, N_R, N_T, times, @mmse_qr_fun);
    y4(i + 1) = fer_test_fun2(i, N_R, N_T, times, @mmse_sqrd_fun);
end
% for i=1:20
%     y1(i + 1) = ber_test_fun(i, N_R, N_T, times, @mmse_sqrd_fun);
% end
% parfor i = 0:20
%     y1(i + 1) = fer_test_fun(i, N_R, N_T, times, @vblast_fun);
%     y2(i + 1) = fer_test_fun(i, N_R, N_T, times, @qr_fun);
%     y3(i + 1) = fer_test_fun(i, N_R, N_T, times, @sqrd_fun);
% end
for i = 0:20
    fprintf("ZF信噪比：%f,误码率:%e\n", i, y1(i + 1) * 100);
    fprintf("MMSE信噪比：%f,误码率:%e\n", i, y2(i + 1) * 100);
    fprintf("MMSE-QR信噪比：%f,误码率:%e\n", i, y3(i + 1) * 100);
    fprintf("MMSE-SQRD信噪比：%f,误码率:%e\n", i, y4(i + 1) * 100);
end

semilogy(x,y1,"r-*",x,y2,"g-*",x,y3,"b-*",x,y4,"m-*")
ylabel("FER")
xlabel("$\frac{E_{b}}{N_{0}}$ in dB","Interpreter","latex")
legend('ZF','MMSE','MMSE-QR','MMSE-SQRD','Location','best')
% title("信号在不同算法和在不同信噪比下的误码率")
t=toc;
fprintf("发射天线数为%d,接收天线数为：%d,数据帧数为%f,仿真完成的时间为：%f秒\n",N_T,times,N_R,t)