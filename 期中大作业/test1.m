H=[2 1 2;3 4 1;3 2 2];
C=[1,2,1]';
V=[1,1,0.5]';
x=H*C+V
G=pinv(H);
arr_size=size(H);
max_norm=0;
max_list=0;
for i=1:arr_size(1)
    temp=norm(H(i,:));
    if temp>max_norm
        max_norm=temp;
        max_list=i;
    end
end
y=H(max_list,:)*x