function c = ml_fun(H,x)
%ML_FUN 该函数实现最大似然检测（ML）算法
%   输入参数H：信道矩阵
%   输入参数x：接收到的信号
%   输出参数c：解调出来的信号矩阵
[row,col]=size(H);%求信道矩阵H的大小
total_num=2^col;
total_probability_t=2*ones(col,total_num);
i=1;
while 1%生成发射信号的所有可能
    randan_arr=randi([0,1],col,1);
    for j=1:total_num
        if randan_arr==total_probability_t(:,j)
            break;
        end
        if j==total_num
            total_probability_t(:,i)=randan_arr;
            i=i+1;
        end
    end
    if i>total_num
        break
    end
end
total_probability_r=H*total_probability_t;%得到接收信号的所有可能
distance=zeros(1,total_num);
for i=1:total_num%计算实际接收到的信号和所有可能的的距离
    distance(1,i)=0;
    for j=1:row
        distance(1,i)=distance(1,i)+(total_probability_r(j,i)-x(j,1))^2;
    end
end
min_distance_index=1;
min_distance=distance(1,1);
for i=1:total_num%找出最小距离所对应的发射信号
    if distance(1,i)<min_distance
        min_distance=distance(1,i);
        min_distance_index=i;
    end
end
c=total_probability_t(:,min_distance_index);%返回得到的发射信号
end

