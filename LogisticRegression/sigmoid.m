function [ g ] = sigmoid( z)
%此函数为预测函数H的实现
% 不论X是一个实数还是一个向量，都要能计算
[m,n]=size(z);
g=zeros(m,n);
for i=1:m
    for j=1:n
        g(i,j)=1/(1+exp(-z(i,j)));
    end
end
end

