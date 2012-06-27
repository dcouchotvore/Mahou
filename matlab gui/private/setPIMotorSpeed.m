function setPIMotorSpeed(motor_index, speed)

global PI_1;

sendPIMotorCommand(1,sprintf('VEL 1 %f\n', speed), 0);
