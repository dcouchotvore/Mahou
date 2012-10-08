function [out,chopperOn] = lookChopper(nChopStates,chopperSignal,varargin)
%lookChopper Analyze the chopper signal to sort the data as
%chopped/unchopped. 
%    out = lookChopper(nSignals,chopperSignal) search the data to find
%    shots above the default threshold (2.5V). If  M =
%    length(chopperSignal), and nSignals = 4, then out is a matrix of size
%    (nSignals,M), where out(1,:) and out(2,:) will be exclusive indices
%    into the high and low states of the chopperSignal, respectively.
%
%    For double chopping, nChopStates = 4, then chopperSignal should be
%    (2,nChopStates). The output is determined byt hte following table
%
%    chop1 chop2 | out1 out2 out3 out4
%     H      H   |  H    L    L    L
%     H      L   |  L    H    L    L
%     L      H   |  L    L    H    L
%     L      L   |  L    L    L    H
%
%    [out,chopperOn] = lookChopper(...) returns a logical value to indicate
%    if the chopper is running correctly or not. Must be H/L for exactly
%    nShots/nSignals. This is relatively strict checking. 
%
%TODO:
%    Features not yet implemented:
%    1) propterty value pairs for optional arguements
%    2) user specified chopperLevel
%    3) adjust strictness of checking

chopperLevel = 2^15; %(16 bit = 2^16 = 5V, divide by 2 for 2.5V = 2^15)

%process optional arguments here
out = zeros(nChopStates,length(chopperSignal));

switch nChopStates
  case 1
    %do nothing because 
  case 2
    out(1,:) = (chopperSignal>chopperLevel);
    out(2,:) = ~out(1,:);
  case 4
    a = chopperSignal(1,:)>chopperLevel;
    b = chopperSignal(2,:)>chopperLevel;
    out(1,:) = a&b;
    out(2,:) = a&~b;
    out(3,:) = ~a&b;
    out(4,:) = ~a&~b;
    
  otherwise
    error('SRGLAB:unknowncase','nSignals = %f not allowed. only 1, 2, 4 supported',nChopStates)
end

if nargout >= 2
  chopperOn = 0;
  if sum(out(1,:))==length(chopperSignal)/(nChopStates/2)
    chopperOn = 1;
  end      
end
