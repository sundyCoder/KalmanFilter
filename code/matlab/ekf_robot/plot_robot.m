
clear all
clc;
close all;
mode = 1;

% Robot length  (6.12cm)
s.L = 0.0612;
% Robot wheel length (1.952cm)
s.W = 0.0195;

% The height of beacon (40cm)
s.Height = 0.40;

% Position of Beacon1
s.B1 = [0, 0];  
% Position of Beacon2
s.B2 = [0, 0.54];

% s.x = [ 0.4251; 0.0639; 6.2632];   % test2
% s.x = [ 0.6571; 0.1215;  6.0039];  % test3
 s.x = [ 0; 0; 0];  % example
% % State transition matrix
% s.A = [1, 0, 0.1;
%        0, 1, 0.1;
%        0, 0, 1];

% Define a process noise:
s.Q = 1e3*eye(3);
%s.Q = 1*eye(3);

% % Observation Matrix
% s.H = [0.1, 0.1,0;
%        0.1, 0.1,0;
%        0,0, 1];
% Define a measurement error :
s.R = 1e2*[0.1,0,0;
           0,0.1,0;
           0,0,0.1];
   
% Do not define any system input (control) functions:
% s.B = 0;
% s.u = 0;
% Do not specify an initial state:
s.P = 10e6*eye(3);

% Sensor data
% [fname, fpath] = uigetfile(...
%     {'*.txt', '*.*'}, ...
%     'Pick a file');

data = load('./data/example.txt');
[row, column] = size(data);

% Calibrate north angle paraell with x axis(test2)
% for i = 1:row
%     if (data(i,4) >= 70) && (data(i,4) < 180)    
%         data(i,4) = data(i,4) - 70;        
%     else
%         data(i,4) = data(i,4) + 290;
%     end       
% end

data(:,4)=(data(:,4)/180)*pi;
% Left, Right Wheel running distance
data(:,5:6) = (data(:,5:6)/512)*(1/28)*(12/30)*pi*s.W;

if mode == 1
    data(:,2:3) = data(:,2:3).^2;
elseif mode == 2
    data(:,2) = data(:,2).^2  - s.Height^2;
    data(:,3) = data(:,3).^2  - s.Height^2;
end

% + 0.01*randn(size(data(:,2:3))); %distance noise

% Save the analysis data to txt format
fileID = fopen('./data/exp.txt','w');
fprintf(fileID,'%f %f %f %f %f %f\n',data');

aa=[];
figure
if mode == 1
    for i=1:row
       y = (data(i,2) - data(i,3) + 0.54.^2)/(2*0.54);
       x = sqrt(data(i,2) - 0.54.^2 - y.^2);    
%        if ~isreal(x)
%           aa=[aa,i];
%        end
       plot(x,y,'o');
%        pause(0.01);
       hold on;
    end
elseif mode == 2     
    for i=1:row
%         if i == 60
%             s.P = 10e10*eye(3);
%         end
        s.z = data(i,2:4)';
        s.z1 = data(i,4:6);
        s = kalmanf_robot(s);
        rx = s.x(1);
        ry = s.x(2);
        plot(rx,ry,'-o');
%         pause(0.01);
        hold on;
    end
end
% remove error data
% data = load('test3_ori.txt');
% data(aa,:)=[];
% fileID = fopen('test3.txt','w');
% fprintf(fileID,'%f %f %f %f %f %f\n',data');

