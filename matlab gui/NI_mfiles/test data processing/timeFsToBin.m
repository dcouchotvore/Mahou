function bins = timeFsToBin(time,options)
% Convert time in ps to bins (units of HeNe fringes)

global fringeToFs
zerobin = options.bin_zero;
bins = round(time/fringeToFs) + zerobin;
