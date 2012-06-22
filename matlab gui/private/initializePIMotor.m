function initializePIMotor(hObject)
% Initialize the motor

% We are setting parameters up for now, but after interfaces are more
% standardized, this should occur earlier when parameter settings are
% loaded.

% Find a serial port object.
devspec.type = 'serial';
devspec.os_name = 'COM7';
devspec.baud = 38400;
devspec.terminator = {'LF','LF'};

cc = devspec.os_name;
obj = instrfind('Type', 'serial', 'Port', cc, 'Tag', '');

% Create the serial port object if it does not exist
% otherwise use the object that was found.
if isempty(obj)
    obj = serial(PI_PORT);
else
    fclose(obj);
    obj = obj(1)
end

% update handles structure

handles = guidata(hObject);
handles.PI_1_obj = devspec;
guidata(hObject, handles);

% Connect to instrument object, obj1.
fopen(obj);

% Configure instrument object, obj1.
set(obj, 'BaudRate', devspec.baud);
set(obj, 'Terminator', devspec.terminator);

%%
fprintf(obj,'*IDN?');
fscanf(obj,'%s')

%% reference move to negative limit
fprintf(obj,'RON 1 1');
fprintf(obj,'FNL');

%% move to an absolute position
fprintf(obj,'MOV 1 1.93')
