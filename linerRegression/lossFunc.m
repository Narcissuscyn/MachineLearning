function [ loss,dw,db ] = lossFunc( X,W,b,Y )
%   ¼ÆËãËğÊ§º¯Êı
H=X*W+b;
dh=(H-Y);
dw=X'*dh;
db=sum(dh(:));
loss=sum(0.5*(dh.^2));
end

