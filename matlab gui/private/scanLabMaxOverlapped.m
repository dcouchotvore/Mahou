function [data,avg_data] = scanLabMaxOverlapped(labMax,handles,params,data,avg_data,i_scan,hPlots)

global PI_1;

%if first scan set up the powermeter acquisition and initialize variables
if i_scan == 1
  %initialize code goes here
  labMaxCommandHandshake(labMax, 'CONF:DISP:PRI');
  labMaxCommandHandshake(labMax, 'CONF:RANG:AUTO ON');
  labMaxCommandHandshake(labMax, 'CONF:READ:CONT STRE');
end

%set scan index to 1 if we are in an infinite loop (this i_scan is only in
%scope inside this function)
if params.scan_max == -1, i_scan = 1;end
%for i_scan = 1:params.scan_max
  
  %move to the start position
  moveMotorFs(handles,1,data(i_scan).x(1),800, 0, 0);
  % start the scan

  %acquire the current data point from meter
  moveMotorFs(handles,1,data(i_scan).x(params.shots),params.speed, 0, 1);    %Better to start LabMax first?
  labMaxCommandHandshake(labMax, 'INIT');
  flag_done = false;
  while ~flag_done
    data7 = labMaxQueryHandshake(labMax, 'FETC:NREC?');
    nrecs = [];
    while isempty(nrecs)
      nrecs = sscanf(data7,'%i');
      data7 = data7(2:end); %if reading didn't work throw away leading char and try again???
    end
    
    if nrecs >= params.shots, flag_done = true;end
  end
  labMaxCommandHandshake(labMax, 'ABOR');
  
%% update the gui
%  h = eval(sprintf('handles.edtMotor%i',1));
%  pos = getMotorPos(1);
%  set(h, 'String', num2str((pos-PI_1.center)*PI_1.factor));

%% read the data from the meter (the slow step)
  data8 = cell(1,params.shots);
  fprintf(labMax,'FETC:ALL?');
  for i = 1:params.shots;
    data8{i} = fgets(labMax);
  end
  handshake(labMax,true);
  
  %convert the strings to numeric
  for i = 1:params.shots
    data(i_scan).y(i) = sscanf(data8{i},'%E',1);
  end
 
  %dummy code
  refreshdata(hPlots,'caller');
  drawnow;

%package output
%x data doesn't change in this style

%% accumulate the average
  if i_scan == 1
    avg_data.y = data(1).y;
  else
    avg_data.y = (avg_data.y.*(i_scan-1) + data(i_scan).y)./i_scan;
  end
%end

