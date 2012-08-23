function time = binToTimeFs(bin, zero_bin)
% Convert bins back to fs

global fringeToFs
time = (bin - zero_bin)*fringeToFs;
