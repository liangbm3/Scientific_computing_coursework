function c=mmse_fun(H,x,n)
%MMSE_FUN 此函数是对MMSE的仿真实现
%   输入参数H：信道矩阵
%   输入参数x：接收到的信号
%   输入参数n：噪声的标准差
%   输出参数c：解调出来的信号矩阵
[~,col]=size(H);%计算H的列数
    I=n*eye(col);
    G=inv(H'*H+I)*H';%得到G矩阵
    c=G*x;
    [row2,col2]=size(c);
    for i=1:row2%遍历元素进行判决
        for j=1:col2
            if c(i,j)<0.5
                c(i,j)=0;
            else
                c(i,j)=1;
            end
        end
    end
end

