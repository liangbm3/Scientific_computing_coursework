function  compare2(N_R,N_T,times)
%COMPARE1 此函数实现对v-blast，ZF,v-blast-svd，ZF-svd,的对比
x=0:1:20;
y1 = zeros(21, 1);
y2 = zeros(21, 1);
y3 = zeros(21, 1);
y4 = zeros(21, 1);
for i = 0:20
    y1(i + 1) = ber_test_fun(i, N_R, N_T, times, @vblast_fun);
    y2(i + 1) = ber_test_fun(i, N_R, N_T, times, @zf_fun);
    y3(i + 1) = ber_test_svd_fun(i, N_R, N_T, times, @vblast_svd_fun);
    y4(i + 1) = ber_test_svd_fun(i, N_R, N_T, times, @zf_svd_fun);
end
figure(2)
semilogy(x,y1,"r-*",x,y2,"b-*",x,y3,"k-<",x,y4,"m-<")
ylabel("BER")
xlabel("$\frac{E_{b}}{N_{0}}$ in dB","Interpreter","latex")
legend('V-blast','Zero-Forcing','V-blast-SVD','Zero-Forcing-SVD','Location','best')
title("信号在不同算法和在不同信噪比下的误码率")
end

