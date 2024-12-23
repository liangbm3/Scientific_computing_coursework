function  compare3(N_R,N_T,times)
%COMPARE1 此函数实现对qrd,mmse-qrd的对比
x=0:1:20;
y1 = zeros(21, 1);
y2 = zeros(21, 1);
for i = 0:20
    y1(i + 1) = ber_test_fun(i, N_R, N_T, times, @qr_fun);
    y2(i + 1) = ber_test_gmd_fun(i, N_R, N_T, times, @qr_gmd_fun);
end
figure(3)
semilogy(x,y1,"r-*",x,y2,"b-*")
ylabel("BER")
xlabel("$\frac{E_{b}}{N_{0}}$ in dB","Interpreter","latex")
legend('QRD','QRD-GMD','Location','best')
title("信号在不同算法和在不同信噪比下的误码率")
end

