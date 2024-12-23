function c = qr_fun(H,x)
%QR_FUN 此函数是对未排序QR算法的仿真实现
%   输入参数H：信道矩阵
%   输入参数x：接收到的信号
%   输出参数c：解调出来的信号矩阵
[~,col]=size(H);%求信道矩阵H的列数
c=zeros(col,1);
[Q,R]=qr(H);%对信道矩阵进行QR分解
y=Q'*x;%对接收到的信号进行处理
d=zeros(col,1);
z=zeros(col,1);
for i=col:-1:1%从最后一层开始检测
    for j=i+1:col%通过迭代获得每一层的干扰项
        d(i,1) = d(i,1) + R(i, j) * c(j,1);
    end
    z(i,1) = y(i,1) - d(i,1);%减去干扰项
    tmp = z(i,1) / R(i, i);%获得原始解调出来的信号
        if tmp < 0.5%对信号进行判决
            c(i,1) = 0;
        else
            c(i,1) = 1;
        end
end
end


