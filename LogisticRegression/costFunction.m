function [ cost,d_theta ] = costFunction( X,Y,theta)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
[m,n]=size(X);%获取theta的行数
d_theta=zeros(n,1);
d_sum=0;

%向量化实现：
%cost= -1 * sum( y .* log( sigmoid(X*theta) ) + (1 - y ) .* log( (1 - sigmoid(X*theta)) ) ) / m ;
%d_theta=(X'*(sigmoid(X*theta)-y))/m

%计算成本函数
cost=-1 * sum( Y .* log( sigmoid(X*theta) ) + (1 - Y ) .* log( (1 - sigmoid(X*theta)) ) ) / m ;

%循环实现
for j=1:n
    for i=1:m
        d_sum=d_sum+(sigmoid(sum(theta'.*X(i,:)))-Y(i))*X(i,j);
    end
    d_theta(j)=(1/m)*d_sum;
    d_sum=0;
end

end

