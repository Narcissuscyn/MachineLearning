function [ loss,dw,db ] = lossFunc( X,W,b,Y )
%   ������ʧ����
H=X*W+b;
dh=(H-Y);
dw=X'*dh;
db=sum(dh(:));
loss=sum(0.5*(dh.^2));
end

