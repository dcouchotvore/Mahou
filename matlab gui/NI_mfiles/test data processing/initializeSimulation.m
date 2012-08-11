function out = initializeSimulation(options)
%initializeSimulation.m initializes function handles for simulating a 2D
%scan
global fringeToPs 

inputfile_name = options.inputfile_name; %'igram_inputfile';
igram_amp = options.IR_voltage; 
bw_cm = options.IR_fwhm;
hene_amp = options.HeNe_modulation;
hene_off = options.HeNe_offset;
hene_phase = options.HeNe_phase*pi/180;%convert deg to rad

%calculate analytical response functions and 2D spectrum with the cumulant
%expansion. This calculates a complex valued 2D spectrum called P, the
%frequency axis w, the time axis t among other things. NB the units of time
%in the simulation are ps, while the time in the data acquisition program 
%is in fs! Watch out!
eval(inputfile_name);


%temp starts as the real valued spectrum as a function of (w3,w1)
temp = real(P{1});

ind = 1:floor(n_t/2);
t1 = t(ind);%ps from simulation

% calculate signal in the mixed (w3,t1) domain by back fft w1->t1
temp = ifftshift(temp,2);
%temp(:,1) = temp(:,1)*0.5;
%signal = real(ifft(temp,[],2));
signal = real(sgrsifft(temp,[],2));

% make a function which interpolates between these points to give a general
% value for any time freq pair. Note the abs(t1i). This enforces that the
% output spectrum be symmetric. This is not 100% correct. For negative
% times the population time actually changes (this assumes it is constant)
% this could be fixed by recalculating response functions for different
% population times and putting those values in. Messy. So I'm doing the
% easy thing now.
signal_fxn = @(t1i,wi) interp2(t1,w,signal(:,ind),abs(t1i(:))',wi(:),'spline',0);

% ok IR interferogram
%bw_cm = 250; %FWHM of laser pulse in wavenumbers
sig = bw_cm*wavenumbersToInvPs/2.355; %width of gaussian (sigma) = FWHM/2.355
%igram_amp = 2;


igram_fxn = @(t) igram_amp.*exp(-t.^2*4*sig^2).*cos(w_0.*t) + igram_amp;


% HeNe (x,y) signals
%hene_amp = 0.1;
%hene_off = 3;

hene_x_fxn = @(t) hene_off - hene_amp.*sin(2*pi*t/(fringeToPs)-hene_phase);
hene_y_fxn = @(t) hene_off - hene_amp.*cos(2*pi*t/(fringeToPs)-hene_phase);


out = struct('signal_fxn',signal_fxn,...
  'igram_fxn',igram_fxn,...
  'hene_x_fxn',hene_x_fxn,...
  'hene_y_fxn',hene_y_fxn,...
  'center_freq',w_0_cm);
