classdef Method_Show_Shots < Method
%inherits from Method superclass

properties (SetAccess = protected)
  %define specific values for Abstract properties listed in superclass
  
  %our result is a one dimensional spectrum of the intensity on the
  %detector (this should be some generic constructor...)
  result = struct('data',[],...
    'freq',[],...
    'noise',[]);
  %ScanIsRunning and ScanIsStopping are inherited
end

properties (SetAccess = protected)
  sample;
  sorted;
  aux;
  ext; %testing external channels for uitable
  signal = struct('data',[],'std',[],'freq',[]);  
  
  PARAMS = struct('nShots',500,'nScans',-1,'chan',65);
  
  source = struct('sampler',[],'gate',[],'spect',[],'motors',[]);

  %TODO: split source to separate objects
%   sampler;
%   gate;
%   spect;
%   motors;
  
  freq;
  
  nSignals = 2;
  nPixels = 64;
  nExtInputs = 16;
  nChan = 80;
  ind_array1 = 1:32;
  ind_array2 = 33:64;
  ind_igram = 65;
  ind_hene_x = 79;
  ind_hene_y = 80
  ind_ext = 65:80;
  
  nShotsSorted;
  i_scan;

end

properties (Dependent, SetAccess = protected)
  Raw_data;
  Diagnostic_data;
  Noise;
end

%
% public methods
%
methods
  function obj = Method_Show_Shots(sampler,gate,spect,motors,handles,hParamsPanel,hMainAxes,hRawDataAxes,hDiagnosticsPanel)
    %constructor
    
    if nargin == 0
      %put actions here for when constructor is called with no arguments,
      %which will serve as defaults. 
      obj.sample = 1;
      return
    elseif nargin == 1
      %If item in is a method class object, just return that object.
      if isa(obj,'Method_Show_Spectrum')
        return
      elseif isa(obj,'Method')
        %what to do if it is a different class but still a Method? How does
        %that work? take FPAS and IO values and handles, delete input object,
        %and call constructor with those input arguments (one level of
        %recursion I guess). Will that work?
        return
      end
    end
    
    obj.source.sampler = sampler; %is there a better way?
    obj.source.gate = gate;
    obj.source.spect = spect;
    obj.source.motors = motors;
    obj.hMainAxes = hMainAxes;
    obj.hParamsPanel = hParamsPanel;
    obj.hRawDataAxes = hRawDataAxes;
    obj.hDiagnosticsPanel = hDiagnosticsPanel;
    obj.handles = handles;
    
    Initialize(obj);
    
%     InitializeFreqAxis(obj);
%     InitializeParameters(obj,hParamsPanel);
%     ReadParameters(obj);
%     InitializeData(obj);
%     InitializeMainPlot(obj);
%     InitializeRawData(obj);
%     InitializeDiagnostics(obj);
  
  %inherited public methods:
  %ScanStop
  end
end

%
% private (protected) methods
%
methods (Access = protected)
  %initialize sample, signal, background, and result. Called at the 
  %beginning of a scan
  function InitializeData(obj)
    
    obj.sample = zeros(obj.nChan,obj.PARAMS.nShots);
    obj.nShotsSorted = obj.nArrays*obj.PARAMS.nShots/obj.nSignals;
    obj.sorted = zeros(obj.nPixelsPerArray,obj.nShotsSorted,obj.nSignals);
    obj.signal.data = zeros(obj.nSignals,obj.nPixelsPerArray);
    obj.signal.std = zeros(obj.nSignals,obj.nPixelsPerArray);
    if isempty(obj.background.data),
      obj.background.data = zeros(obj.nSignals,obj.nPixelsPerArray);
      obj.background.std = zeros(obj.nSignals,obj.nPixelsPerArray);
    end
    obj.result.data = zeros(1,obj.PARAMS.nShots);
    obj.result.noise = zeros(1,obj.nPixelsPerArray);

    obj.ext = zeros(obj.nExtInputs,1);
    obj.aux.igram = zeros(1,obj.PARAMS.nShots);
    obj.aux.hene_x = zeros(1,obj.PARAMS.nShots);
    obj.aux.hene_y = zeros(1,obj.PARAMS.nShots);
    
  end
    
  function InitializeFreqAxis(obj)
    obj.freq = 1:obj.PARAMS.nShots;
  end
  
  %set up the plot for the main output. Called by the class constructor.
  function InitializeMainPlot(obj)
    %attach signal to main plot
    obj.hPlotMain = 0;
    
    % !!! Important note: Cannot use 'hold off' here because of side
    % effects.  This is equivalent.
    set(obj.hMainAxes,'Nextplot','replacechildren');
    %hold(obj.hMainAxes,'off');
    
    %obj.hPlotMain = bar(obj.hMainAxes,obj.freq,obj.result.data,'hist');
    obj.hPlotMain = plot(obj.hMainAxes,obj.freq,obj.result.data,'g');
    set(obj.hPlotMain,'XDataSource','obj.freq',...
      'YDataSource','obj.result.data')

    %set(obj.hPlotMain,'FaceColor','none','EdgeColor',[0 1 0]);
    set(obj.hMainAxes,'Xlim',[obj.freq(1) obj.freq(end)]);
    
  end
  
  function InitializeUITable(obj)
    set(obj.handles.uitableExtChans,'Data',obj.ext,'columnformat',{'short g'});
  end
  
  function RefreshUITable(obj)
    set(obj.handles.uitableExtChans,'Data',obj.ext);
  end
  
  %set up the ADC task(s)
  function InitializeTask(obj)
    %close gate
    obj.source.gate.CloseClockGate;
    
    %configure task
    obj.source.sampler.ConfigureTask(obj.PARAMS); 
  end
  
  %initialize the data acquisition event and move motors to their
  %starting positions
  function ScanInitialize(obj)
    ReadParameters(obj);
    
    InitializeFreqAxis(obj);
    
    InitializeData(obj);

    InitializeTask(obj);
    %just leave motors where they are
  end
  
  %start first sample. This code is executed before the scan loop starts
  function ScanFirst(obj)
    %start the data acquisition task
    obj.source.sampler.Start;
    obj.source.gate.OpenClockGate;
  end
  
  %This code is executed inside the scan loop. This is different from
  %ScanFirst for efficiency. It allows us to read data from ScanFirst
  %(making sure it is finished), then immediately start the second, and
  %process the first while the second is acquiring. It is also the place
  %to put code to save temporary files
  function ScanMiddle(obj)
    obj.sample = obj.source.sampler.Read; %this will wait until the required points have been transferred (ie it will finish)
    obj.source.gate.CloseClockGate;
    %any other reading can happen next
    
    %no need to move motors
    
    %start the data acquisition task
    obj.source.sampler.Start;
    obj.source.gate.OpenClockGate;

    %process the previous results
    ProcessSample(obj);
    
    %no averaging
    %obj.AverageSample(obj);
    
    %plot results
    RefreshPlots(obj,obj.hPlotMain)
    RefreshPlots(obj,obj.hPlotRaw)
    UpdateDiagnostics(obj);
    RefreshUITable(obj);
    drawnow
    
    %no saving
  end
  
  %This code executes after the scan loop. It should read but not start a
  %new scan. It should usually save the final results.
  function ScanLast(obj)
    obj.sample = obj.source.sampler.Read; %this will wait until the required points have been transferred (ie it will finish)
    obj.source.gate.CloseClockGate;
    %any other reading can happen next
    
    %no need to move motors
    
    %process the previous results
    ProcessSample(obj); %this is a public method of the Method superclass
    
    %no averaging
    %obj.AverageScan(obj);
    
    %plot results
    RefreshPlots(obj,obj.hPlotMain)
    RefreshPlots(obj,obj.hPlotRaw)
    UpdateDiagnostics(obj);
    RefreshUITable(obj);
    drawnow
    %no saving
    
  end
  
  %move the motors back to their zero positions. Clear the ADC tasks.
  function ScanCleanup(obj)
    obj.source.gate.CloseClockGate;
    obj.source.sampler.ClearTask;
    %no need to move motors back to zero
  end
   
  function ProcessSampleSort(obj)
    %the easy thing
    
    obj.sorted(:,:,1) = obj.sample(obj.ind_array1,1:obj.nShotsSorted);
    obj.sorted(:,:,2) = obj.sample(obj.ind_array2,1:obj.nShotsSorted);

    obj.aux.igram = obj.sample(obj.ind_igram,:);
    obj.aux.hene_x = obj.sample(obj.ind_hene_x,:);
    obj.aux.hene_y = obj.sample(obj.ind_hene_y,:);
    obj.ext = obj.sample(obj.ind_ext,:);
    
    %unfinished:
%     rowInd1 = obj.ind_array1;
%     rowInd2 = obj.ind_array2;
%     chop = 0; %this is a vector nSignals/nArrays in length 
%     
%     colInd1 = (1:obj.nSignals/obj.nArrays:obj.PARAMS.nShots)+chop;
%     colInd2 = (1:obj.nSignals/obj.nArrays:obj.PARAMS.nShots)+chop;
%     count = 0;
%     for ii = 1:2:obj.nSignals/2;
%       count = count+1;
%       obj.sorted(:,:,ii) = obj.sample(rowInd1,obj.nShotsSorted);
%       obj.sorted(:,:,ii+1) = obj.sample(obj.nPixelsPerArray+1:2*obj.nPixelsPerArray,obj.nShotsSorted);
%     end 
  end

  function ProcessSampleAvg(obj)
    obj.signal.data = squeeze(mean(obj.sorted,2))';
    obj.signal.std = squeeze(std(obj.sorted,0,2))';
    obj.ext = mean(obj.ext,2);
  end
  
  function ProcessSampleBackAvg(obj)
    obj.background.data = (obj.background.data.*(obj.i_scan-1) + obj.signal.data)./obj.i_scan;
    %check this might not be right
    obj.background.std = sqrt((obj.background.std.^2.*(obj.i_scan-1) + obj.signal.std.^2)./obj.i_scan);
  end
  
  function ProcessSampleSubtBack(obj)
    %obj.signal.data = obj.signal.data - obj.background.data;
    %obj.signal.std = sqrt(obj.signal.std.^2 + obj.background.std.^2);
    
    %here we are going to subtract the background from every shot we have
    %measured. Note that the backgrounds for different signals may be
    %different so we must do this after sorting the data. Normally one
    %would do this with a nested for loop, but that is slow in Matlab, so
    %we will use the fancy function bsxfun (binary function (ie two
    %operands) with singleton dimension expansion) to acheive this. We are
    %subtracting the sorted data (size nPixels, nShots, nSignals) minus the
    %bg which has size nPixels 1 nSignals). The bsxfun realizes that the
    %middle dimension 1 needs to match nShots so it expands the size of the
    %array automatically. 
    
    % Background might have been saved with another method.  Make sure
    % the dimensions agree.
    % @@@@ could be optimized with next step.
    if size(obj.background)~=[obj.nPixelsPerArray, obj.nSignals]
      obj.background = obj.background.';
    end
    
    %So we first transpose the background from (nSignals x nPixels) to
    %(nPixels x nSignals). Reshape expands that to be (nPixels x 1 x
    %nSignals).
    bg = reshape(obj.background.data',[obj.nPixelsPerArray 1 obj.nSignals]);
    
    %now bsxfun does the subtraction
    obj.sorted = bsxfun(@minus,obj.sorted,bg);
  end

  function ProcessSampleResult(obj)
    %calculate the effective delta absorption (though we are plotting the
    %signals directly)
    obj.result.data = obj.sample(obj.PARAMS.chan,:);
  end
  
  function ProcessSampleNoise(obj)
    %calculate the signal from each shot for an estimate of the error
    obj.result.noise = 1000 * std(log10(obj.sorted(:,:,1)./obj.sorted(:,:,2)),0,2)'/sqrt(obj.PARAMS.nShots);

    %the other option would be a propagation of error calculation but I
    %haven't worked through that yet. See wikipedia Propagation of
    %Uncertainty
  end
end

methods %public methods
  
  function out = get.Raw_data(obj)
    out = obj.signal.data;
  end
  function out = get.Noise(obj)
    out = obj.result.noise;
  end
  
    function delete(obj)
        DeleteParameters(obj);
    end
    

end

        
%
% other inherited methods
%
% ScanStop(obj)
% InitializeRawDataPlot(hAxesRawData)
% InitializeDiagnostics(hDiagnosticsPanel)
% UpdateDiagnostics(hDiagnosticsPanel)
% RefreshPlots(hAxes)

end


