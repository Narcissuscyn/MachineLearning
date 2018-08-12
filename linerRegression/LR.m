%generate test data
clear;
lossout=fopen('loss.txt','w+');

[X,Y]=initData();
W=rand(5,1);
b=rand;
step=0.001;
for i=1:1000
    [loss,dw,db]=lossFunc(X,W,b,Y);
    fprintf(lossout,'%f\n',loss);
    W=W-step*dw;
    b=b-step*db;   
end
%º∆À„h_pre;

