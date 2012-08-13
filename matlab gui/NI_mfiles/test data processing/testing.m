
[T1,T3] = meshgrid(t,t);

P1=exp(1i*w_0.*(-T1+T3)+1i*phi).*exp(-g(T1)+g(t2)-g(T3)-g(T1+t2)-g(t2+T3)+g(T1+t2+T3)).*(2-2.*exp(-sqrt(-1)*anh.*T3));
P2=exp(1i*w_0.*(T1+T3)+1i*phi).*exp(-g(T1)-g(t2)-g(T3)+g(T1+t2)+g(t2+T3)-g(T1+t2+T3)).*(2-2.*exp(-sqrt(-1)*anh.*T3));
PP=exp(1i*w_0.*(-T1+T3)+1i*phi).*exp(-g(T1)+g(t2)-g(T3)-g(T1+t2)-g(t2+T3)+g(T1+t2+T3)).*(2-2.*exp(-sqrt(-1)*anh.*T3)) + ...
  ... % + exp(1i*w_0.*(-T1+T3)+1i*phi).*exp(-g(-T1)+g(t2)-g(T3)-g(-T1+t2)-g(t2+T3)+g(-T1+t2+T3)).*(2-2.*exp(-sqrt(-1)*anh.*T3)) ...
  + exp(1i*w_0.*(T1+T3)+1i*phi).*exp(-g(T1)-g(t2)-g(T3)+g(T1+t2)+g(t2+T3)-g(T1+t2+T3)).*(2-2.*exp(-sqrt(-1)*anh.*T3))...
  ... % + exp(1i*w_0.*(-T1+T3)+1i*phi).*exp(-g(-T1)-g(t2)-g(T3)+g(-T1+t2)+g(t2+T3)-g(-T1+t2+T3)).*(2-2.*exp(-sqrt(-1)*anh.*T3))...
  ;
%PP = real(PP);
P1_t = P1;
P2_t = P2;
PP_t = PP;
        
PP=sgrsfft2(PP,n_zp);
PP = real(fliplr(circshift(PP,[0 -1])));
   
figure(21)
my2dPlot(w,w,fftshift(real(PP(2:end,2:end))),'n_contours',20,'pumpprobe',false)






%%

figure(22)
subplot(2,1,1),
plot(t,real(P2_t(1,:)))
subplot(2,1,2),
plot(t,real(PP_t(1,:)))

%% other way
analyticalResponseFunctionsInputFile

%this is uh(w3,w1)
uh = real(P{1});

figure(30),clf
my2dPlot(w,w,uh,'n_contours',20,'pumpprobe',false)

% calculate uh(w3,t1)
uh = ifftshift(uh,2);
uh(:,1) = uh(:,1)*0.5;
uh_t = real(ifft(uh,[],2));
figure(31),clf
my2dPlot(w,w,uh_t,'n_contours',20,'pumpprobe',false)

 
figure(32),clf
plot(w,uh_t(:,1))

%% throw out "negative" times
t1 = t(1:floor(n_t/2));
uhh = uh_t(:,1:floor(n_t/2));
%uhh = uh_t;
%uhh(:,ceil(n_t/2):end) = 0;

figure(33),clf
my2dPlot(t1,w,uhh,'n_contours',20,'pumpprobe',false)
%contourf(uhh);

% back transform to see if the 2D spectrum is still right

uhh(:,1) = uhh(:,1).*0.5;
uhhh = real(fftshift(fft(uhh,n_zp,2),2));

ww = fftFreqAxis(t1,...
  'time_units','ps',...
  'freq','wavenumbers',...
  'shift','on',...
  'zeropad',n_zp,...
  'undersampling',n_under);
figure(34),clf
my2dPlot(ww,w,uhhh,'n_contours',20,'pumpprobe',false)

%% test interpolation inline functions
dat_x = [0:10];
dat_y = exp(-dat_x/2);
figure(1),clf
plot(dat_x,dat_y,'o')

hf = @(xi) interp1(dat_x,dat_y,xi,'cubic',0);
xi = [0:0.1:11];
yi = feval(hf,xi);
figure(2),clf
plot(dat_x,dat_y,'o',xi,yi,'-')

%% ok... go for 2d function

hf2 = @(t1i,wi) interp2(t1,w,uh_t(:,1:floor(n_t/2)),abs(t1i(:))',wi(:),'spline',0);

%test input t and w
n_pixels = 32;
res = 30;
w_center = w_0_cm;
t_start = -0.250;
t_end = 0.300;
n_steps = 100;

%t_in = [0:1:n_t/2,-n_t/2:1:1]*dt;
t_in = linspace(t_start,t_end,n_steps);

w_in = [-(n_pixels-1)/2:1:(n_pixels-1)/2]*res + w_center;

figure(3),clf,
my2dPlot(t_in,w_in,hf2(t_in,w_in),'n_contours',20,'pumpprobe',false)

%% ok interferogram
bw_cm = 250; %FWHM of laser pulse in wavenumbers
sig = bw_cm*wavenumbersToInvPs/2.355; %width of gaussian (sigma) = FWHM/2.355
igram_amp = 2;
pulse_igram = @(t) -igram_amp.*exp(-t.^2*4*sig^2).*cos(w_0.*t) + igram_amp;

figure(4),clf
plot(t_in,pulse_igram(t_in),'-o')

%% HeNe (x,y) signals
hene_amp = 0.1;
hene_off = 3;

hene_x = @(t) hene_off - hene_amp.*cos(2*pi*t/(fringeToFs/1000));
hene_y = @(t) hene_off - hene_amp.*sin(2*pi*t/(fringeToFs/1000));

t_in = -0.020:0.0002:0.02;
figure(5),clf,
plot(t_in,hene_x(t_in),'-o',t_in,hene_y(t_in),'-o')

%% gives a circle good
figure(6),clf
plot(hene_x(t_in),hene_y(t_in),'o')

%% try a function to do all of that


options.inputfile_name = 'igram_inputfile';
options.IR_voltage = 2; %volts on the detector
options.IR_fwhm = 250; %in cm-1
options.HeNe_modulation = 0.1; %+/- volts caused by interference
options.HeNe_offset = 3; %offset voltage 
options.t_start = -0.500;
options.t_end = 1;
options.fringes_per_shot = 0.25;
options.laser_rep_rate = 5000;
options.acceleration = 10;


out = initializeSimulation(options);

% save the freq axis
n_pixels = 32;
res = 30;
%w_center = w_0_cm;
w_center = out.center_freq;

freq = [-(n_pixels-1)/2:1:(n_pixels-1)/2]*res + w_center;
options.freq = freq;


t_profile = rampProfile(options);
figure(9),
plot(t_profile)

%% see if it works with above

s = feval(out.signal_fxn,t_profile,freq);
i = feval(out.igram_fxn,t_profile);
hx = feval(out.hene_x_fxn,t_profile);
hy = feval(out.hene_y_fxn,t_profile);

close all
figure(1),clf
my2dPlot(t_profile,freq,s,'n_contours',20,'pumpprobe',false)

figure(2),clf
plot(t_profile,i)

figure(3),clf
plot(hx)
hold on
plot(hy,'g')
hold off

%package into data block
n_shots = length(t_profile);
data = zeros(80,n_shots);

i_i = 65;
i_hx = 67;
i_hy = 68;

data(1:32,1:n_shots) = s;
data(33:64,1:n_shots) = 1; %ref channel is arbitrarily 1 for now
data(i_i,1:n_shots) = i;
data(i_hx,1:n_shots) = hx;
data(i_hy,1:n_shots) = hy;

%% try it all together

options.inputfile_name = 'igram_inputfile';
options.IR_voltage = 2; %volts on the detector
options.IR_fwhm = 250; %in cm-1
options.HeNe_modulation = 0.1; %+/- volts caused by interference
options.HeNe_offset = 3; %offset voltage 
options.HeNe_phase = 0; %degrees (I am not sure this is correct yet)
options.n_scans = 1;
options.t_start = -500;%fs
options.t_end = 1000; %fs
options.fringes_per_shot = 0.15;
options.laser_rep_rate = 5000;
options.acceleration = 1;
options.spectrometer_n_pixels = 32;
options.spectrometer_resolution = 30; %wavenumbers
options.bin_zero = 4000; %define this before min and max for the lines below to work
options.bin_min = timeFsToBin(options.t_start,options)+1;
options.bin_max = timeFsToBin(options.t_end,options)-1;
options.timing_error = 10; %fs (I am not sure this is correct yet)

%%
out = initializeSimulation(options);

%%
[time,freq,data] = simulateData(out,options);

%% test it
%figure(1),clf
spec = data(1:32,:)./data(33:64,:);
n_t = length(time);
figure(2),clf
my2dPlot(1:n_t,freq,spec,'n_contours',20,'pumpprobe',false)

%% try out Duane's code for processing the position
data_trim = data(:,501:510);
[position,bin] = processPosition(data_trim,options) %CW :-)

%%
data_trim = data(:,8001:8010);
[position,bin] = processPosition(data_trim,options) %CCW :^)

%%
[position,bin] = processPosition(data,options)

%% put data into bins and average this scan (no chopper)
d = data;
n_bins = options.bin_max - options.bin_min + 1;

[position,bin] = processPosition(d,options);
bin_data = zeros(64,n_bins); %could try these as sparse matrices
bin_count = zeros(1,n_bins);
bin_igram = zeros(1,n_bins);
b_axis = options.bin_min:options.bin_max; %for plotting etc

nShots = size(d,2);


for ii = 1:nShots
    %jj is which column of the data matrix are we adding that shot to
    jj = bin(ii) - options.bin_min + 1;
    
    %filter bins above max and below min
    if (jj <= 0) || (jj > n_bins), continue, end
    bin_data(:,jj) = bin_data(:,jj) + d(1:64,ii);
    bin_igram(jj) = bin_igram(:,jj) + d(65,ii);
    bin_count(jj) = bin_count(jj) + 1;
end
ind = find(bin_count>0);
fprintf(1,'bin\tcount\n');
fprintf(1,'%i \t%i\n',[b_axis(ind);bin_count(ind)])

%% average over bins (probably after all scans are done?) 
%either loop or use repmat on the bin_count to expand it to the 64 channels
for ii = 1:64
    bin_data(ii,1:n_bins) = bin_data(ii,1:n_bins)./bin_count(1:n_bins);
end
bin_igram(1,1:n_bins) = bin_igram(1,1:n_bins)./bin_count(1:n_bins);

%% now calc sig/ref
signal = zeros(32,n_bins);
signal = bin_data(1:32,:)./bin_data(33:64,:);

figure(1),clf
my2dPlot(t_axis,freq,signal,'n_contours',20,'pumpprobe',false)

%% phasing
[phase,analysis]=phasing2dPP(t_axis*1000,bin_igram)
