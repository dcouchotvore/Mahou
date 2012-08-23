function [time,freq,data] = simulateData(out,options)

%generate the time axis for the forward/back scan
t_profile = rampProfile(options);

% save the freq axis
n_pixels = options.spectrometer_n_pixels;
res = options.spectrometer_resolution;
%w_center = w_0_cm;
w_center = out.center_freq;

freq = [-(n_pixels-1)/2:1:(n_pixels-1)/2]*res + w_center;

s = feval(out.signal_fxn,t_profile,freq);
i = feval(out.igram_fxn,t_profile);
hx = feval(out.hene_x_fxn,t_profile);
hy = feval(out.hene_y_fxn,t_profile);



%package into data block
n_shots = length(t_profile);
data = zeros(80,n_shots);

%indicies for other channels
i_i = 65;
i_hx = 79;
i_hy = 80;

data(1:32,1:n_shots) = s;
data(33:64,1:n_shots) = 1; %ref channel is arbitrarily 1 for now
data(i_i,1:n_shots) = i;
data(i_hx,1:n_shots) = hx;
data(i_hy,1:n_shots) = hy;

time = t_profile*1000;