function new_position = moveMotorFs(handles,motor_index,desired_position)
% put the code to move motors here. The desired position and new position
% are in units of fs. The command should return a number indicating where
% it got to, which could be different from the command (due to hitting a
% limit switch, etc)

%dummy code
%pause(0.1);

% Convert fs to mm.
CONVERT_FACTOR=666.667;
new_position = desired_position/CONVERT_FACTOR + motor_offset;

%str = get(handles.editSpeed, 'String')
%calllib('DLLInterface', 'SetParameter', 'PI_TranslationStage1', 'Speed', str);
calllib('DLLInterface', 'GoTo', 'PI_TranslationStage1', num2str(new_position), 1);

%update the gui
h = eval(sprintf('handles.edtMotor%i',1));
[pos]=calllib('DLLInterface', 'Poll', 'PI_TranslationStage1');
set(h,'String',num2str((pos-motor_offset)*CONVERT_FACTOR));
