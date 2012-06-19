function new_position = moveMotorFs(handles,motor_index,desired_position, move_relative)
% put the code to move motors here. The desired position and new position
% are in units of fs. The command should return a number indicating where
% it got to, which could be different from the command (due to hitting a
% limit switch, etc)

global PI_1;
%dummy code
%pause(0.1);
CONVERT_FACTOR = 1666.667;

if move_relative
  pos = getMotorPos(motor_index);
  desired_position = (pos-PI_1.center)*CONVERT_FACTOR+desired_position;
  desired_position = getMotorPos(1)+desired_position;
end

% Convert fs to mm.
new_position = desired_position/CONVERT_FACTOR + PI_1.center;

if new_position<PI_1.minimum
  new_position = PI_1.minimum;
elseif new_position>PI_1.maximum
  new_position = PI_1.maximum;
end


%% move to an absolute position
res = query(PI_1.object, '*IDN?');
fprintf(PI_1.object, 'MOV 1 %f\n', new_position);

%% Wait until stage reaches target
%val = queryMotorNoTerminator(PI_1.object, char(5));
%while val~=0
%  val = queryMotorNoTerminator(PI_1.object, char(5));
%end
ref = -1.0;
pos = getMotorPos(1);
while ref~=pos
  ref = pos;
  pause(0.1);
  pos = getMotorPos(1);
end

%% update the gui
h = eval(sprintf('handles.edtMotor%i',1));
pos = getMotorPos(motor_index);
set(h, 'String', num2str((pos-PI_1.center)*CONVERT_FACTOR));
