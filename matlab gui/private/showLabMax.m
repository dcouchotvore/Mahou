function [data,avg_data] = showLabMax(handles,params,data,avg_data,i_scan)

%if first scan set up the powermeter acquisition and initialize variables
if i_scan == 1
  %initialize code goes here
end

%acquire current data point from meter

%dummy code
drawnow;
pause(0.5); 
%ind = mod(i_scan-1,n_points)+1;
%y = rand;

%package output
%x data doesn't change in this style
data.y = rand; %update y data

%accumulate the average
avg_data.y = (avg_data.y.*(i_scan-1) + data.y)./i_scan;