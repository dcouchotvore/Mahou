function bins = timePsToBin(time,options)
% Convert time in ps to bins (units of HeNe fringes)

global fringeToPs
zerobin = options.bin_zero;
bins = round(time/fringeToPs) + zerobin;
