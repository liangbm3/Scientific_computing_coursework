function [q,r] = my_qr_fun(H)
%MY_QR_FUN 该函数实现qr分解
q=H;
[~,col]=size(q);%计算H的列数 
for i=1:col
    r(i,i)=norm(q(:,i));
    q(:,i)=q(:,i)/r(i,i);
    for j=i+1:col
        r(i,j)=q(:,i)'*q(:,j);
        q(:,j)=q(:,j)-r(i,j)*q(:,i);
    end
end
end







