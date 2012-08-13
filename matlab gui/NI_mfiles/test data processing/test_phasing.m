
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
options.timing_error = 100; %fs (I am not sure this is correct yet)

out = initializeSimulation(options);

n_bins = options.bin_max - options.bin_min + 1;
bin_data = zeros(64,n_bins); %could try these as sparse matrices
bin_count = zeros(1,n_bins);
bin_igram = zeros(1,n_bins);
b_axis = options.bin_min:options.bin_max; %for plotting etc
t_axis = binToTimeFs(b_axis,options);

%% could be a scan loop
for i_scan = 1:options.n_scans
  [time,freq,data] = simulateData(out,options);

  % put data into bins and average this scan (no chopper)
  d = data;
  
  [position,bin] = processPosition(d,options);
  
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
end

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
[phase,t0_bin_shift,analysis]=phasing2dPP(t_axis,bin_igram)

%% calculate spectrum
s = construct2dPP;
s.freq = freq;
s.time = t_axis;
s.bin = b_axis;
s.zeropad = 1024;
s.PP = signal;
s.t0_bin = find(s.bin==options.bin_zero) - t0_bin_shift;

s = absorptive2dPP(s)
