function [ cost,d_theta ] = costFunction( X,Y,theta)
%UNTITLED3 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
[m,n]=size(X);%��ȡtheta������
d_theta=zeros(n,1);
d_sum=0;

%������ʵ�֣�
%cost= -1 * sum( y .* log( sigmoid(X*theta) ) + (1 - y ) .* log( (1 - sigmoid(X*theta)) ) ) / m ;
%d_theta=(X'*(sigmoid(X*theta)-y))/m

%����ɱ�����
cost=-1 * sum( Y .* log( sigmoid(X*theta) ) + (1 - Y ) .* log( (1 - sigmoid(X*theta)) ) ) / m ;

%ѭ��ʵ��
for j=1:n
    for i=1:m
        d_sum=d_sum+(sigmoid(sum(theta'.*X(i,:)))-Y(i))*X(i,j);
    end
    d_theta(j)=(1/m)*d_sum;
    d_sum=0;
end

end

