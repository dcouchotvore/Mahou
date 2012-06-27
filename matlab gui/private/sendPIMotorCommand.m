function result = sendPIMotorCommand(motor_index, msg, expect_response)

global PI_1;

% This hogwash is to guarantee a single terminating line feed rather 
% one is provided in the input or not.  I thought the MATLAB serial object
% was supposed to add/manage terminators, but apparently it doesn't.
message = deblank(msg);

if expect_response~=0
  result = query(PI_1.object, message);
else
  result = '';
  fprintf(PI_1.object, message);
end

error_code = query(PI_1.object, 'ERR?');
if error_code(1)~='0'
  error('Motor error code %s: %s\n', deblank(error_code), message);
end