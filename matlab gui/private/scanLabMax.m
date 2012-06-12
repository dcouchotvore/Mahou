function [data,avg_data] = scanLabMax(handles,params,data,avg_data,i_scan,hPlots)

%if first scan set up the powermeter acquisition and initialize variables
if i_scan == 1
  %initialize code goes here
  
end

%set scan index to 1 if we are in an infinite loop (this i_scan is only in
%scope inside this function)
if params.scan_max == -1, i_scan = 1;end
for i_step = 1:length(data(1).x)
  
  %move to the desired position
  moveMotorFs(handles,1,data(i_scan).x(i_step));
  
  %acquire the current data point from meter (random now)
  data(i_scan).y(i_step) = rand;
  
  %dummy code
  refreshdata(hPlots,'caller');
  drawnow;
end


%package output
%x data doesn't change in this style


%accumulate the average
if i_scan == 1
    avg_data.y = data(1).y;
else
  avg_data.y = (avg_data.y.*(i_scan-1) + data(i_scan).y)./i_scan;
end