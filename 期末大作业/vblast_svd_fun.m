function c = vblast_svd_fun(H,x)
%VBLAST_FUN 此函数是对v-blast-svd算法的仿真实现
%   输入参数H：信道矩阵
%   输入参数x：接收到的信号
%   输出参数c：解调出来的信号矩阵
[~,col]=size(H);%获取H矩阵的大小
c_hat=zeros(col,1);
index=1:col;%用于记录解调顺序的索引
c=zeros(col,1);
[U,S,~]=svd(H);%SVD分解
x=inv(U)*x;%左乘U的逆
H=S;%信号矩阵变为对角阵
for i=1:col%进行迭代
    [~,col]=size(H);
    G=pinv(H);%求出矩阵H的伪逆
    k=1;
    v=norm(G(1,:));
    for j=1:col%找出伪逆G中二范数最小的行
        temp=norm(G(j,:));
        if temp<v
            v=temp;
            k=j;
        end
    end
    c_hat(index(k),:)=G(k,:)*x;%得到近似解
        if c_hat(index(k),:)>0.5%对近似解进行判决
            c(index(k),:)=1;
        else 
            c(index(k),:)=0;
        end 
    x=x-H(:,k)*c(index(k),:);%将改成判决得到的信号从x中减去
    index(k)=[];%更新索引    
    H(:,k)=[];%删去H对应的列
end

