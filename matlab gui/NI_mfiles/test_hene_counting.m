close all; clear all; startup;

global PARAMS;
PARAMS.nShots = 10000;
PARAMS.dataSource = 0;
PARAMS.noiseGain = 1;
PARAMS.speed = 1200;
PARAMS.start = 0;
PARAMS.stop = 1000;

global IO;
IO = IO_Interface;
IO.CloseClockGate();

fig1=figure;
h = uicontrol('Parent',fig1,'Tag','editMotor1','Style','edit');
handles.editMotor1 = h;

Interferometer_Stage = PI_TranslationStage('COM3', 0.4537, 'editMotor1');

%load library
lib = 'myni';	% library alias
if ~libisloaded(lib)
    disp('Matlab: Load nicaiu.dll')
    funclist = loadlibrary('nicaiu.dll','C:\Program Files (x86)\National Instruments\NI-DAQ\DAQmx ANSI C Dev\include\nidaqmx.h','alias',lib);
    %if you do NOT have nicaiu.dll and nidaqmx.h
    %in your Matlab path,add full pathnames or copy the files.
    %libfunctions(lib,'-full') % use this to show the... 
    %libfunctionsview(lib)     % included function
end
disp('Matlab: dll loaded')

% %% load all DAQmx constants
if ~exist('flag_NIconstants_defined','var') || ~flag_NIconstants_defined
    NIconstants;    
end
disp('done')

%% reset device
devName = 'Dev1'; %as defined in NI MAX program
DAQmxResetDevice(lib,'Dev1');

%% create task
%propteries of the array detector
nPixels = 64;
nExtInputs = 16;
nShots = PARAMS.nShots; %number of laser shots to acquire
maxChan = 256; %the number of channels written to the FIFO buffer in the FPAS

% for later use the total number of channels from the electronics (not the
% same as the number of digital input/output channels, which is just 1)
nChan = nPixels + nExtInputs;

lines = {'Dev1/line0:31'};
taskName = '';	% ?
chanName = {''};	% recommended to avoid problems
lineGrouping = DAQmx_Val_ChanForAllLines; % One Channel For All Lines

[hTask,numchan] = DAQmxCreateDIChan(lib,lines,lineGrouping,taskName,chanName);
%here numchan is the number of digital input channels, i.e. just 1

%% configure timing

sampleMode = DAQmx_Val_FiniteSamps;
sampsPerChan = maxChan/2*nShots+1; %nChan/2+1; %total number of points to acquire #Ch*#scans (where scans is NI language for shots)
sampleClkRate = 10e6;%10 MHz
sampleClkOutputTerm = '/Dev1/PFI4'; %note leading front slash. Why needed here???
sampleClkPulsePolarity = DAQmx_Val_ActiveHigh;
pauseWhen = DAQmx_Val_High;
readyEventActiveLevel = DAQmx_Val_ActiveHigh;

DAQmxCfgBurstHandshakingTimingExportClock(lib,hTask,...
    sampleMode,sampsPerChan,sampleClkRate,sampleClkOutputTerm,...
    sampleClkPulsePolarity,pauseWhen,readyEventActiveLevel);


%% set input buffer size
bufSizeInSamps = sampsPerChan*numchan;
DAQmxCfgInputBuffer(lib,hTask,bufSizeInSamps);

%% set DMA transfer
DAQmxSetDIDataXferMech(lib,hTask,chanName,DAQmx_Val_DMA);


%% commit (make everything as ready to go as it can be)
DAQmxTaskControl(lib,hTask,DAQmx_Val_Task_Commit);

%% start the task
DAQmxStartTask(lib,hTask);

%% read 
timeout = 1000;
fillMode = DAQmx_Val_GroupByChannel; % Group by Channel
%fillMode = DAQmx_Val_GroupByScanNumber; % I think this doesn't matter when only 1 channel

IO.OpenClockGate();
Interferometer_Stage.MoveTwoStep(PARAMS.start, PARAMS.stop, PARAMS.speed)
obj.position = 0;

disp('stage should be moving');
pause(5);     
            
[portdata,sampsPerChanRead] = DAQmxReadDigitalU32(lib,hTask,numchan,sampsPerChan,timeout,fillMode,bufSizeInSamps);

%portdata

%% stop
DAQmxStopTask(lib,hTask);

%% clear
DAQmxClearTask(lib,hTask);

%% swizzle data (could be optimized for memory and speed)
nPerBoard = 32; %has to do with the number of channels on the boards going to the FIFO
 
ind = [];
for ii = 1:ceil(nChan/nPerBoard)
  ind = [ind,[1:2:15 2:2:16; 17:2:31 18:2:32]+(ii-1)*32];
end
ind = ind(:);

%how many channels do you need to keep to unravel all the data correctly
maxInd = ceil(nChan/nPerBoard)*nPerBoard; 

%throw away first point because it is empty
hm = portdata(2:end);

%throw away as many points as we can without losing information
hm = reshape(hm,maxChan/2,nShots);
hm = hm(1:maxInd/2,:);

%flatten again
hm = hm(:); 

%convert each 32bit number to two 16bit numbers
hmm = typecast(hm,'uint16');
hmm = reshape(hmm,maxInd,nShots);

%use ind to sort the data
IND = repmat(ind,1,nShots); %this only needs to happen once per scan
data = zeros(size(IND)); %initialize size of array (once per scan)
%data = hmm(IND);
data = hmm(ind,1:nShots);

% extract array part and ext channels part
array = double(data(1:nPixels,:)); %the first 64 rows
ext = double(data((nPixels+1):(nPixels+nExtInputs),:))./13107; %the last 16 rows divided by some magic number I don't understand to make volts?

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


  [position,bin] = processPosition(double(data),options);

 range = [2000:2100];
 d = double(data(:,range));
 henex = d(79,:);
heney = d(80,:);
figure
plot(henex,heney,'-o')

  [position,bin] = processPosition(d,options);

  

 range = [1:10000];
 d = double(data(:,range));
 henex = d(79,:);
heney = d(80,:);
figure
plot(henex,heney,'.')

  [position,bin] = processPosition(d,options);
  
  figure(4),plot(bin)
  