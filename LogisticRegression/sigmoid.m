function [ g ] = sigmoid( z)
%�˺���ΪԤ�⺯��H��ʵ��
% ����X��һ��ʵ������һ����������Ҫ�ܼ���
[m,n]=size(z);
g=zeros(m,n);
for i=1:m
    for j=1:n
        g(i,j)=1/(1+exp(-z(i,j)));
    end
end
end

