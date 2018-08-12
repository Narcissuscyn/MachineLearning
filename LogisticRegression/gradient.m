function [] = gradient( X,y,theta )
lossout=fopen('loss.txt','w+');
step=0.0005;
for i=1:1000
    [cost,db]=costFunction(X,y,theta);
   % cost;
   fprintf(lossout,'%f\n',cost);
    theta=theta-step*db;
end
end

