function C=zf_fun_img(H,x)
%ZF_FUN_IMG 此函数是对ZF复数信号的仿真实现
%   输入参数H：信道矩阵
%   输入参数x：接收到的信号
%   输出参数C：解调出来的信号矩阵
    G=pinv(H);%求信道矩阵H的伪逆
    c=G*x;%得到初始信号
    [row,col]=size(c);
    distance=zeros(1,4);
    C=zeros(row,col);
    for i=1:row%遍历每个元素进行判决
        for j=1:col
            distance(1,1)=real(c(i,j))^2+imag(c(i,j))^2;
            distance(1,2)=real(c(i,j))^2+(imag(c(i,j))-1)^2;
            distance(1,3)=(real(c(i,j))-1)^2+imag(c(i,j))^2;
            distance(1,4)=(real(c(i,j))-1)^2+(imag(c(i,j))-1)^2;
            min_index=find(distance==min(distance));
            if min_index==1
            C(i,j)=0+0i;
            elseif min_index==2
                C(i,j)=0+1i;
            elseif min_index==3
                C(i,j)=1+0i;
            else
                C(i,j)=1+1i;
            end
        end
    end
end

