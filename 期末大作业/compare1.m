function  compare1(N_R,N_T,times)
%COMPARE1 此函数实现对v-blast，QRD，SQRD，ZF,MMSE，MMSE-QRD，MMSE-SQRD，MMSE-SQRD-PSA的对比
x=0:1:20;
y1 = zeros(21, 1);
y2 = zeros(21, 1);
y3 = zeros(21, 1);
y4 = zeros(21, 1);
y5 = zeros(21, 1);
y6 = zeros(21, 1);
y7 = zeros(21, 1);
y8 = zeros(21, 1);
for i = 0:20
    y1(i + 1) = ber_test_fun(i, N_R, N_T, times, @vblast_fun);
    y2(i + 1) = ber_test_fun(i, N_R, N_T, times, @qr_fun);
    y3(i + 1) = ber_test_fun(i, N_R, N_T, times, @sqrd_fun);
    y4(i + 1) = ber_test_fun(i, N_R, N_T, times, @zf_fun);
    y5(i + 1) = ber_test_fun(i, N_R, N_T, times, @mmse_fun);
    y6(i + 1) = ber_test_fun(i, N_R, N_T, times, @mmse_qr_fun);
    y7(i + 1) = ber_test_fun(i, N_R, N_T, times, @mmse_sqrd_fun);
    y8(i + 1) = ber_test_fun(i, N_R, N_T, times, @mmse_sqrd_psa_fun);
end
figure(1)
semilogy(x,y1,"r-*",x,y2,"k-*",x,y3,"b-*",x,y4,"c-*",x,y5,"m-*",x,y6,"r-<",x,y7,"k-<",x,y8,"b-<")
ylabel("BER")
xlabel("$\frac{E_{b}}{N_{0}}$ in dB","Interpreter","latex")
legend('V-blast','Unsorted QRD','Sorted QRD','Zero-Forcing','MMSE','MMSE-QRD','MMSE-SQRD','MMSE-SQRD-PSA','Location','best')
title("信号在不同算法和在不同信噪比下的误码率")
end

