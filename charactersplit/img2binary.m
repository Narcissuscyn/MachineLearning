function homework6_charater_recognition
clc
close all

%% 选择文件
load photo_png\number\BPnet net

[FileName,PathName] = uigetfile('*.png','选择一张图片','photo_png\');
if isequal(FileName,0)
   disp('没选择图片，请重新运行！')
   return
end
   
Irgb = imread(fullfile(PathName,FileName));

%% 显示
fig1 = figure;
imshow(Irgb)
title('单击此图片选择另一图片识别')
pos1 = get(fig1,'Position');
set(fig1,'Position',[10 pos1(2:4)]);

set(fig1,'WindowButtonDownFcn',@BtnDownFcn);

%% 识别
Iycbcr = rgb2ycbcr(Irgb);
fig2 = figure;
recognition(Iycbcr,net);
pos2 = get(fig2,'Position');
set(fig2,'Position',[pos1(3)+20 pos1(2) pos2(3:4)]);

%% 鼠标单击响应
    function BtnDownFcn(h,evt)
       
        [FileName,PathName] = uigetfile('*.png','选择一张图片','photo_png\');
        if isequal(FileName,0)
            disp('没选择图片，请重新选择！')
            return
        end
       
        Irgb = imread(fullfile(PathName,FileName));
       
        figure(fig1)
        imshow(Irgb)
        title('单击此图片选择另一图片识别')
       
        Iycbcr = rgb2ycbcr(Irgb);
        figure(fig2)
        recognition(Iycbcr,net);
       
    end

end


%% 字符识别
function recognition(Iycbcr,net)
%% 提取室牌区域
% 阈值
cb_range.low = 75; % 84(80)
cb_range.high = 102; % 90(100)
cr_range.low = 125; % 135(130)
cr_range.high = 142; % 142(145)

% 提取各分量
Igray = double(Iycbcr(:,:,1));
cb = Iycbcr(:,:,2);
cr = Iycbcr(:,:,3);

% 据阈值提取有效颜色区域
Icb = zeros(size(cb));
Icr = zeros(size(cr));
Icb(cb>=cb_range.low & cb<=cb_range.high) = 1;
Icr(cr>=cr_range.low & cr<=cr_range.high) = 1;

Itemp = Icb.*Icr;

subplot(221)
imshow(Icb.*Icr)
title('颜色分量提取有效颜色区域')

%% 闭运算处理，去除干扰
s = strel('disk',8);
Iclose = imclose(Itemp,s);

subplot(223)
imshow(Iclose)
title('闭运算处理')

%% 查找字符区域
Ilabel = bwlabel(Iclose,4); % 字符标记

N = max(max(Ilabel));
pixelcount = zeros(N,1);
for i = 1:N
    pixelcount(i) = numel(find(Ilabel==i));
end

if length(find(pixelcount>1000)) >= 2 % 对于有实验室牌子的干扰
    pixelcount(pixelcount==max(pixelcount)) = 0;
end

[yyy,index] = max(pixelcount);
Isector = zeros(size(Ilabel));
Isector(Ilabel==index) = 1;

%% 提取字符区域
[row,col] = find(Ilabel==index);
exrow.min = min(row);
exrow.max = max(row);
excol.min = min(col);
excol.max = max(col);

temp1 = find(Ilabel==index);
meanvalue = sum(sum(Igray(temp1)))/length(temp1); % 得到截取部分的灰度平均值，便于后面二值化

Iex1 = Igray;
Iex1(Ilabel~=index) = -1;
Iarea = Iex1(exrow.min:exrow.max,excol.min:excol.max);
Iarea(Iarea==-1) = 255;

subplot(322)
imshow(mat2gray(Iarea))
title('提取')

%% 二值化
Iarea_bw = Iarea<meanvalue/1.15; % FIXME，比例值可改

subplot(324)
imshow(mat2gray(Iarea_bw))
title('二值化')

%% 字符分割
Iarea_label = bwlabel(Iarea_bw,8);

M = max(max(Iarea_label));
pixelcount1 = zeros(M,1);
for i = 1:M
    pixelcount1(i) = numel(find(Iarea_label==i));
end

pixelcount1_sort = sort(pixelcount1,'descend');
pixelcount1(pixelcount1<pixelcount1_sort(3)) = 0;
numindex = find(pixelcount1~=0);

for i = 1:3
    [temprow,tempcol] = find(Iarea_label==numindex(i));
    exrow.min = min(temprow);
    exrow.max = max(temprow);
    excol.min = min(tempcol);
    excol.max = max(tempcol);
   
    result{i} = Iarea_label(exrow.min:exrow.max,excol.min:excol.max);
end

subplot(3,6,16)
imshow(result{1}>=1)
t1 = title('');

subplot(3,6,17)
imshow(result{2}>=1)
t2 = title('');

subplot(3,6,18)
imshow(result{3}>=1)
t3 = title('');

%% 字符识别--BP神经网络
for i = 1:3
    q = NumbertoNetIO(result{i}>=1);
    number(i) = sim(net,q);
end

set(t1,'string',abs(round(number(1))))
set(t2,'string',abs(round(number(2))))
set(t3,'string',abs(round(number(3))))

end

%% 产生神经网络的输入输出向量
function q = NumbertoNetIO(Im)
wcount = 4;
hcount = 6;

[h,w] = size(Im);
wseg = round(w/wcount);
hseg = round(h/hcount);

tmp = zeros(wcount,hcount);
for i = 1:wcount
    if i == wcount
        windex = (i-1)*wseg+1:w;
    else
        windex = (i-1)*wseg+1:i*wseg;
    end
    for j = 1:hcount
       
        if j == hcount
            hindex = (j-1)*hseg+1:h;
        else
            hindex = (j-1)*hseg+1:j*hseg;
        end
       
        seg = Im(hindex,windex);
       
        tmp(i,j) = sum(sum(seg))/numel(seg);
    end
end

q = tmp(:);
end

 

%% 利用分割好的数字图片进行神经网络训练，数字图片的文件名以图片数字开头
function nettrain
clc
close all

%% 样本
file = dir('*.png');

N = length(file);

%%
num = 24;
p = zeros(num,N); % 输入向量
t = zeros(1,N); % 目标向量
for kk=1:N
    % 形成输入变量
    Im = imread(file(kk).name); % 读取图像
    p(:,kk) = NumbertoNetIO(Im);
   
    % 形成目标向量
    t(kk) = str2double(file(kk).name(1));
end

%%
pr(1:num,1)=0;
pr(1:num,2)=1;

% 创建两层BP神经网络，隐层有25个节点
net=newff(pr,[10 1],{'logsig' 'purelin'},'traingdx','learngdm');
net.trainParam.epochs=5000;
net.trainParam.goal=0.001;
net.trainParam.show=10;
net.trainParam.lr=0.05;

% 训练神经网络
net=train(net,p,t);

% 存储训练好的神经网络
save BPnet net

end

%% 产生神经网络的输入输出向量，输入为将图片分成24份，24份的白色比例作为输入
function q = NumbertoNetIO(Im)
wcount = 4;
hcount = 6;

[h,w] = size(Im);
wseg = round(w/wcount);
hseg = round(h/hcount);

tmp = zeros(wcount,hcount);
for i = 1:wcount
    if i == wcount
        windex = (i-1)*wseg+1:w;
    else
        windex = (i-1)*wseg+1:i*wseg;
    end
    for j = 1:hcount
       
        if j == hcount
            hindex = (j-1)*hseg+1:h;
        else
            hindex = (j-1)*hseg+1:j*hseg;
        end
       
        seg = Im(hindex,windex);
       
        tmp(i,j) = sum(sum(seg))/numel(seg);
    end
end

q = tmp(:);
end