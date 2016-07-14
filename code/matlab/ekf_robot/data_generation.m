clear all
clc
close all

X(1,1) = 0.40^2;
Y(1,1) = 0.40^ + 0.54^2;
B1 = [0,0];
B2 = [0,0.54];

%模拟到Beacon1的距离
DB1(1,1) = sqrt(0.4^2);  
%模拟到Beacon2的距离
DB2(1,1) = sqrt(0.54^2 + 0.4^2);
%模拟左右轮的圈数
Tick = 4690;
TL(1,1) = Tick;
TR(1,1) = Tick;
%模拟指北针矫正到平行于X轴的角度
Theta(1,1) = 0;
Time(1,1) = 1;

for i = 2:200
    inc = 0.008*i;
    Y(:,i) = 0;
    X(:,i) = inc;
    DB1(:,i) = sqrt(inc^2 + 0.40^2);
    DB2(:,i) = sqrt(inc^2 + 0.40^2 + 0.54^2);
    TL(:,i) = Tick;
    TR(:,i) = Tick;
    Theta(:,i) = 0;
    Time(:,i) = i;
end

%存放数据的矩阵
C = [Time',DB1',DB2',Theta',TL',TR'];

%生成模拟数据文件
fileID = fopen('example.txt','w');
fprintf(fileID,'%f %f %f %f %d %d\n',C');

