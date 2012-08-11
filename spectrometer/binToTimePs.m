function time = binToTimePs(bin,options)
% Convert bins back to fs

global fringeToPs
zerobin = options.bin_zero;
time = (bin - zerobin)*fringeToPs;
