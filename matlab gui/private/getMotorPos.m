function position = getMotorPos(motor_index)
% NOTE: position is returned in motor units, not GUI (typically fs) units.

global PI_1;

result = sendPIMotorCommand(1, 'POS?', 1);
[nums count] = sscanf(result, '%i=%f');
position = nums(2);


