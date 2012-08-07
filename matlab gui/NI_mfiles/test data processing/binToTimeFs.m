function time = binToTimeFs(bin,options)
% Convert bins back to fs

global fringeToFs
zerobin = options.bin_zero;
time = (bin - zerobin)*fringeToFs;
