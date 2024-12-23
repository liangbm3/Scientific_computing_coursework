function c=mmseqr1(H,x,n)
%MMSE_FUN 此函数是对MMSE的仿真实现
%   输入参数H：信道矩阵
%   输入参数x：接收到的信号
%   输入参数n：噪声的标准差
%   输出参数c：解调出来的信号矩阵
[~,col]=size(H);
 I=n*eye(col);
 H=[H;I];
% q=H;
% [~,col]=size(q);%计算H的列数 
% norm_list=zeros(1,col);
% r=zeros(col,col);
% 
% 
%     for i=1:col
%     norm_list(i)=norm(q(i));
%     end
%     for i=1:col
%         r(i,i)=norm_list(i);
%         q(:,i)=q(:,i)/r(i,i);
%         for j=i+1:col
%             r(i,j)=q(:,i)'*q(:,j);
%             q(:,j)=q(:,j)-r(i,j)*q(:,i);
%             norm_list=norm_list-r(i,j)^2;
%         end
%     end
[q,r]=qr(H);
    x=[x;zeros(col,1)];
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

