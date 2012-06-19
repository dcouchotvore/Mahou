
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
fprintf(obj,'*IDN?');
fscanf(obj,'%s')

%% reference move to negative limit
fprintf(obj,'RON 1 1');
fprintf(obj,'FNL');


