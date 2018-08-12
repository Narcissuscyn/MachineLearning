function [ X,Y ] = initData(  )
%   随机生成初始化数据
data_x=fopen('data_x.txt','w+');
X=rand(100,5);
W=[1,2,3,4,5]';
bias=2;
Y=X*W+bias;

for i=1:100
    for j=1:5
        fprintf(data_x,'%f',X(i,j));
        if j<5
            fprintf(data_x,' ');
        end
    end
    if i<100
        fprintf(data_x,'\n');
    end
end
fclose(data_x);

data_y=fopen('data_y.txt','w+');

for i=1:100
    fprintf(data_y,'%f',Y(i));
    if i<100
        fprintf(data_x,'\n');
    end
end

end


