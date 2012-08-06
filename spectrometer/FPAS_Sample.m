function sample = FPAS_Sample(phase,PARAMS)
global FPAS NICONST

%TODO: The fundamental steps are
% case 0 Configure the task
% case 1 Start the task
% case 2 Read and stop the task and swizzle data
% case 3 Clear the task (releasing the card for 
switch PARAMS.dataSource
    
  %% Really go to the hardware
  case 0
    switch phase
      
      % Configure the task
      case 0
        if FPAS.initialized
          FPAS.nSampsPerChan = FPAS.nMaxChan/2*PARAMS.nShots+1; %nChan/2+1; %total number of points to acquire #Ch*#scans (where scans is NI language for shots)
          [FPAS.hTask,FPAS.nChan] = DAQmxCreateDIChan(FPAS.lib,{'Dev1/line0:31'},NICONST.DAQmx_Val_ChanForAllLines,'',{''});
          %here numchan is the number of digital input channels, i.e. just 1
          
          %% configure timing
          
          sampleMode = NICONST.DAQmx_Val_FiniteSamps;
          sampleClkRate = 10e6;%10 MHz
          sampleClkOutputTerm = '/Dev1/PFI4'; %note leading front slash. Why needed here???
          sampleClkPulsePolarity = NICONST.DAQmx_Val_ActiveHigh;
          pauseWhen = NICONST.DAQmx_Val_High;
          readyEventActiveLevel = NICONST.DAQmx_Val_ActiveHigh;
          
          DAQmxCfgBurstHandshakingTimingExportClock(FPAS.lib,FPAS.hTask,...
            sampleMode,FPAS.nSampsPerChan,sampleClkRate,sampleClkOutputTerm,...
            sampleClkPulsePolarity,pauseWhen,readyEventActiveLevel);
          
          %% start the task
        end
          
      % start the task
      case 1
        if FPAS.initialized
          DAQmxStartTask(FPAS.lib, FPAS.hTask);
        end
        
      % read data and swizzle
      case 2
        if FPAS.initialized
          %% read
          timeout = 1;
          fillMode = NICONST.DAQmx_Val_GroupByChannel; % Group by Channel
          %fillMode = DAQmx_Val_GroupByScanNumber; % I think this doesn't matter when only 1 channel

          [portdata,sampsPerChanRead] = DAQmxReadDigitalU32(FPAS.lib,FPAS.hTask,FPAS.nChan,FPAS.nSampsPerChan,timeout,fillMode,FPAS.nSampsPerChan*FPAS.nChan);

          %portdata

          %% stop
          DAQmxStopTask(FPAS.lib,FPAS.hTask);
          
          %% swizzle data (could be optimized for memory and speed)
          nPerBoard = 32; %has to do with the number of channels on the boards going to the FIFO
          
          ind = [];
          for ii = 1:ceil((FPAS.nPixels+FPAS.nExtInputs)/nPerBoard)
            ind = [ind,[1:2:15 2:2:16; 17:2:31 18:2:32]+(ii-1)*32];
          end
          ind = ind(:);
          
          %how many channels do you need to keep to unravel all the data correctly
          maxInd = ceil((FPAS.nPixels+FPAS.nExtInputs)/nPerBoard)*nPerBoard;
          
          %throw away first point because it is empty
          hm = portdata(2:end);
          
          %throw away as many points as we can without losing information
          hm = reshape(hm,FPAS.nMaxChan/2,PARAMS.nShots);
          hm = hm(1:maxInd/2,:);
          
          %flatten again
          hm = hm(:);
          
          %convert each 32bit number to two 16bit numbers
          hmm = typecast(hm,'uint16');
          hmm = reshape(hmm,maxInd,PARAMS.nShots);
          
          sample = hmm(ind,1:PARAMS.nShots);

%           %use ind to sort the data
%           %IND = repmat(ind,1,PARAMS.nShots); %this only needs to happen once per scan
%           data = zeros(FPAS.nPixels+FPAS.nExtInputs,PARAMS.nShots); %initialize size of array (once per scan)
%           data = hmm(ind,1:PARAMS.nShots);
%           
%           
%           %% extract array part and ext channels part
%           sample.data.pixels = double(data(1:FPAS.nPixels,:)); %the first 64 rows
%           sample.data.external = double(data((FPAS.nPixels+1):(FPAS.nPixels+FPAS.nExtInputs),:))./13107; %the last 16 rows divided by some magic number I don't understand to make volts?
          
          % If in simulation mode, duplicate method 2
        else
          %TODO make sample the block of 80 x nShots data
          for ii=1:32
            sample.data.pixels(ii, :)   = abs(sech((ii-14)/6)^2 + random('Normal', 0, .2, 1, PARAMS.nShots));
            sample.data.pixels(ii+32,:) = abs(sech((ii-18)/6)^2 + random('Normal', 0, .2, 1, PARAMS.nShots));
          end
          sample.data.external = random('uniform', 0.0, 5.0, 16, PARAMS.nShots);
        end
        
      % clear task (clean up)
      case 3
        if FPAS.initialized
          %% clear
          DAQmxClearTask(FPAS.lib,FPAS.hTask);
        end
        
    end
    
    %% Uniform Distribution
  case 1
          %TODO make sample the block of 80 x nShots data
    if phase==1
      sample.data.pixels = random('uniform', 0.0, 5.0, 64, PARAMS.nShots);
      sample.data.external = random('uniform', 0.0, 5.0, 16, PARAMS.nShots);
    end
    
    %% Simulate offset sech^2 peaks with Gaussian noise
  case 2
          %TODO make sample the block of 80 x nShots data
    if phase==1
      for ii=1:32
        sample.data.pixels(ii, :)   = abs(sech((ii-14)/6)^2 + random('Normal', 0, .2, 1, PARAMS.nShots));
        sample.data.pixels(ii+32,:) = abs(sech((ii-18)/6)^2 + random('Normal', 0, .2, 1, PARAMS.nShots));
      end
      sample.data.external = random('uniform', 0.0, 5.0, 16, PARAMS.nShots);
    end
    
    %% Simulate matching sech^2 peaks with Gaussian noise on sample to test noise calculations
  case 3
          %TODO make sample the block of 80 x nShots data
    if phase==1
      for ii=1:32
        sample.data.pixels(ii+32,:) = repmat(sech((ii-16)/12)^2 + 0.1, 1, PARAMS.nShots);
        sample.data.pixels(ii,:)    = sample.data.pixels(ii+32,:).*(1+random('Normal', 0.0, 0.00001, 1, PARAMS.nShots));
      end
      sample.data.external = random('uniform', 0.0, 5.0, 16, PARAMS.nShots);
    end
    
    % Simulate spectrum, HeNe interference, and IR interferogram
  case 4
    switch phase
      case 0
        %initialization
        
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
        options.timing_error = 100; %fs 

        sim_fxns = initializeSimulation(options);

        sample.n_bins = options.bin_max - options.bin_min + 1;
        sample.bin_data = zeros(64,n_bins); %could try these as sparse matrices
        sample.bin_count = zeros(1,n_bins);
        sample.bin_igram = zeros(1,n_bins);
        sample.b_axis = options.bin_min:options.bin_max; %for plotting etc
        sample.t_axis = binToTimeFs(b_axis,options);
        sample.options = options; %save these for later use
        sample.sim_fxns = sim_fxns;
        
      case 2
        %run 
        options = sample.options;
          [sample.time,sample.freq,sample.data] = simulateData(sim_fxns,options);


    end       

% TODO: this belongs in the method
% %% Final processing for this sample
% if phase==1
%     sample.mean.pixels = mean(sample.data.pixels, 2);
%     sample.mean.external = mean(sample.data.external, 2);
% 
%     sample.mOD = log10(sample.data.pixels([33:64],:)./sample.data.pixels([1:32],:))*1000;
%     sample.noise = std(sample.mOD, 1, 2);
%     sample.mOD = mean(sample.mOD, 2);
%     sample.abs_noise = (std(sample.data.pixels(16,:))+std(sample.data.pixels(17,:)))/2;
% end
