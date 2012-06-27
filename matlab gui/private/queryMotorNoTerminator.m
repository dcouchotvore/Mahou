function result = queryMotorNoTerminator(motor_index, msg)

global PI_1;

  term = {'', ''};
  set(PI_1.object, 'Terminator', '');
  result = query(PI_1.object, msg);
  set(PI_1.object, 'Terminator', PI_1.terminator);
