function position = getMotorPos(motor_index)
% put the code to move motors here. The desired position and new position
% are in units of fs. The command should return a number indicating where
% it got to, which could be different from the command (due to hitting a
% limit switch, etc)

global PI_1;

result = query(PI_1.object,'POS?');
[nums count] = sscanf(result, '%i=%f');
position = nums(2);
%position = 0.0;


