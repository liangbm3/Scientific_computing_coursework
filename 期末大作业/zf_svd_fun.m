function c=zf_svd_fun(H,x)
%ZF_FUN 此函数是对ZF-SVD的仿真实现
%   输入参数H：信道矩阵
%   输入参数x：接收到的信号
%   输出参数c：解调出来的信号矩阵
[U,S,~]=svd(H);%SVD分解
x=inv(U)*x;%左乘U的逆
H=S;%信号矩阵变为对角阵
    G=pinv(H);%求信道矩阵H的伪逆
    c=G*x;%得到初始信号
    [row,col]=size(c);
    for i=1:row%遍历每个元素进行判决
        for j=1:col
            if c(i,j)<0.5
                c(i,j)=0;
            else
                c(i,j)=1;
            end          
        end
    end
end


