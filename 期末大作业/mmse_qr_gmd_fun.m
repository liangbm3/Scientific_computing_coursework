function c= mmse_qr_gmd_fun(H,x,n)
%MMSE_QR_FUN 此函数对MMSE-QRD-GMD算法的实现
%   输入参数H：信道矩阵
%   输入参数x：接收的信号
%   输入参数n：噪声的方差
[~,col]=size(H);
I=n*eye(col);
H=[H;I];%对信道矩阵进行扩展
[U,S,V]=svd(H);
[q,r,~]=gmd(U,S,V);
x=[x;zeros(col,1)];%对接收的信号进行处理
y=q'*x;%对接收到的信号进行处理
d=zeros(col,1);
z=zeros(col,1);
for i=col:-1:1%从最后一层开始检测
    for j=i+1:col%通过迭代获得每一层的干扰项
        d(i,1) = d(i,1) + r(i, j) * c(j,1);
    end
    z(i,1) = y(i,1) - d(i,1);%减去干扰项
    tmp = z(i,1) / r(i, i);%获得原始解调出来的信号
    if tmp < 0.5%对信号进行判决
        c(i,1) = 0;
    else
        c(i,1) = 1;
    end
end
end

