function bins = timeFsToBin(time, zero_bin)
% Convert time in ps to bins (units of HeNe fringes)

global fringeToFs
bins = round(time/fringeToFs) + zero_bin;
