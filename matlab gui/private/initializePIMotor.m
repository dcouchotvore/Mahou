
function initializePIMotor(hObject)
% Initialize the motor

% We are setting parameters up for now, but after interfaces are more
% standardized, this should occur earlier when parameter settings are
% loaded.

global PI_1;

% Find a serial port object.
PI_1.type = 'serial';
PI_1.os_name = 'COM4';
PI_1.baud = 38400;
PI_1.terminator = {'LF','LF'};
PI_1.maximum = 15.0;
PI_1.minimum = 0.0;
PI_1.center = 0.0;
PI_1.factor = 6666.667;     % units per physical millimeter

cc = PI_1.os_name;
obj = instrfind('Type', 'serial', 'Port', cc, 'Tag', '');

% Create the serial port object if it does not exist
% otherwise use the object that was found.
if isempty(obj)
    obj = serial(PI_1.os_name);
else
    fclose(obj);
    obj = obj(1)
end

PI_1.object = obj;
% update handles structure
%devspec.object = obj;
%handles = guidata(hObject);
%handles.PI_1_obj = devspec;
%guidata(hObject, handles);

% Connect to instrument object, obj1.
fopen(obj);

% Configure instrument object, obj1.
set(obj, 'BaudRate', PI_1.baud);
set(obj, 'Terminator', PI_1.terminator);

%%
sendPIMotorCommand(1, '*IDN?', 1);

%% reference move to negative limit
sendPIMotorCommand(1, 'RON 1 1', 0);
sendPIMotorCommand(1, 'SVO 1 1', 0);
sendPIMotorCommand(1, 'VEL 1 0.5', 0);
sendPIMotorCommand(1, 'FNL 1', 0);

%Wait until motor gets to limit.
while 1==1
  status = sendPIMotorCommand(1, 'SRG? 1 1', 1);
  num = uint16(hex2dec(status(7:end-1)));
  if bitand(num, hex2dec('A000'))==hex2dec('8000')
    break;
  else
    pause(0.1);
  end
end

