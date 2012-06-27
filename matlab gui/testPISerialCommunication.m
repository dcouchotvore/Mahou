% Find a serial port object.
PI_PORT = 'COM4';
obj = instrfind('Type', 'serial', 'Port', PI_PORT, 'Tag', '');

% Create the serial port object if it does not exist
% otherwise use the object that was found.
if isempty(obj)
    obj = serial(PI_PORT);
else
    fclose(obj);
    obj = obj(1)
end

% Connect to instrument object, obj1.
fopen(obj);

% Configure instrument object, obj1.
set(obj, 'BaudRate', 38400);
set(obj, 'Terminator', {'LF','LF'});

%%
fprintf(obj,'*IDN?');
fscanf(obj,'%s')

%% reference move to negative limit
fprintf(obj,'RON 1 1');
fprintf(obj,'FNL');

%% move to an absolute position
fprintf(obj,'MOV 1 1.93')

%% read position
query(obj,'POS?')

%% reset motor
fprintf(obj,'RON 1 0'); %turns referencing off (this is quick and dirty reset)
fprintf(obj,'POS 1 0')

%% clean up
fclose(obj)
delete(obj)
clear obj
