% must be called before all other attempts to communicate with the dll:
loadlibrary('MATLABconnector.dll', 'MATLABconnector.h')

% each call to calllib sends one WM_KEYDOWN/WM_KEYUP pair.
% parameters: function must be called using the brackets as follows, 
% which isn't always the case in MATLAB - this is to ensure that the final
% digit is seen as an integer, not a string.
% Parameters one and two must remain as is here, the third one can be
% changed to indicate which arrow key is being simulated:
% 1 - LEFT
% 2 - RIGHT
% 3 - UP
% 4 - DOWN
% The third parameter can be a variable that is output from another MATLAB
% function, in order to 'drive' the software simulation.
calllib('MATLABconnector', 'fnMATLABconnector', 1)



%final call in the file should be:
unloadlibrary('MATLABconnector')
