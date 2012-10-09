classdef Method_Test_Phasing < Method
%inherits from Method superclass

properties (Hidden,SetAccess = immutable)
  Tag = 'methodscommon';
end

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
  ext;
  signal = struct('data',[],'std',[],'freq',[],'igram',[]);  
  
  PARAMS = struct('nShots',[],'nScans',500,'start',-500, 'end', 1000, ...
      'speed', 1700, 'bin_zero', 4000, 'bin_min', timeFsToBin(-500, 4000)+1, ...
      'bin_max', timeFsToBin(1000, 4000)-20, 'acceleration', 66713 ); % 66713 = 2*fs equiv of 10mm
  
  source = struct('sampler',[],'gate',[],'spect',[],'motors',[]);
  position;
  bin;

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
  ind_hene_y = 80;
  
  nShotsSorted;

  bin_data;
  bin_count;
  bin_igram;
  b_axis;
  t_axis;
  i_scan;

end

properties (Dependent, SetAccess = protected)
  Raw_data;
  Diagnostic_data;
  Noise;
  nBins;
end

%
% public methods
%
methods
  function obj = Method_Test_Phasing(sampler,gate,spect,motors,handles,hParamsPanel,hMainAxes,hRawDataAxes,hDiagnosticsPanel)
    %constructor
    
    if nargin == 0
      %put actions here for when constructor is called with no arguments,
      %which will serve as defaults. 
      obj.sample = 1;
      return
    elseif nargin == 1
      %If item in is a method class object, just return that object.
      if isa(obj,'Method_Test_Phasing')
        return
      elseif isa(obj,'Method')
        %what to do if it is a different class but still a Method? How does
        %that work? take FPAS and IO values and handles, delete input object,
        %and call constructor with those input arguments (one level of
        %recursion I guess). Will that work?
        return
      end
    end
    
    %obj.nBins = obj.PARAMS.bin_max - obj.PARAMS.bin_min +1;
    obj.source.sampler = sampler; %is there a better way?
    obj.source.gate = gate;
    obj.source.spect = spect;
    obj.source.motors = motors;
    obj.hMainAxes = hMainAxes;
    obj.hParamsPanel = hParamsPanel;
    obj.hRawDataAxes = hRawDataAxes;
    obj.hDiagnosticsPanel = hDiagnosticsPanel;
    obj.handles = handles;
    
    obj.saveData = true;

    Initialize(obj);
    
%     InitializeFreqAxis(obj);
%     InitializeParameters(obj,hParamsPanel);
%     ReadParameters(obj);
%     InitializeData(obj);
%     InitializeMainPlot(obj);
%     InitializeRawData(obj);
%     InitializeDiagnostics(obj);
  end
  
  %inherited public methods:
  %ScanStop
end

%
% private (protected) methods
%
methods (Access = protected)
  %initialize sample, signal, background, and result. Called at the 
  %beginning of a scan
  function InitializeParameters(obj)
      %preprocessing goes here...
      
      %call the superclass function
      InitializeParameters@Method(obj); 
      
      set(obj.handles.editnShots,'Enable','off');
  end
  
  function ReadParameters(obj)
      %pre
      
      %super
      ReadParameters@Method(obj);
      
      %post
      %obj.PARAMS.nShots = 10000;  % @@@ DEBUG!
      obj.PARAMS.nShots = 2 * ceil((obj.PARAMS.end-obj.PARAMS.start)/obj.PARAMS.speed)*obj.source.sampler.LASER.PulseRate+1000;
      set(obj.handles.editnShots,'String',num2str(obj.PARAMS.nShots));
  end
  
  function InitializeData(obj)
    
    obj.bin_data = zeros(obj.nChan, obj.nBins);
    obj.bin_count = zeros(1, obj.nBins);
    obj.bin_igram = zeros(1, obj.nBins);
    obj.b_axis = obj.PARAMS.bin_min:obj.PARAMS.bin_max;
    obj.t_axis = binToTimeFs(obj.b_axis, obj.PARAMS.bin_zero);
    
    obj.sample = zeros(obj.nChan,obj.PARAMS.nShots);
    obj.nShotsSorted = obj.nBins;
    obj.sorted = zeros(obj.nPixelsPerArray,obj.nShotsSorted,obj.nSignals);
    obj.signal.data = zeros(obj.nPixelsPerArray,obj.nBins,obj.nSignals);
    obj.signal.std = zeros(obj.nPixelsPerArray,obj.nBins,obj.nSignals);
    if isempty(obj.background.data)
      obj.background.data = zeros(obj.nPixelsPerArray, obj.nSignals);
      obj.background.std = zeros(obj.nPixelsPerArray, obj.nSignals);
    end
    obj.result.data = zeros(1,obj.nPixelsPerArray);
    obj.result.noise = zeros(1,obj.nPixelsPerArray);

    obj.ext = zeros(obj.nExtInputs,1);
    obj.aux.igram = zeros(1,obj.PARAMS.nShots);
    obj.aux.hene_x = zeros(1,obj.PARAMS.nShots);
    obj.aux.hene_y = zeros(1,obj.PARAMS.nShots);
    
  end
    
  function InitializeFreqAxis(obj)
    obj.freq = obj.source.spect.wavenumbersAxis;
    set(obj.hMainAxes,'Xlim',[obj.freq(1) obj.freq(end)]);
  end
  
  function InitializeUITable(obj)
    set(obj.handles.uitableExtChans,'Data',obj.ext);
  end
  
  function RefreshUITable(obj)
    set(obj.handles.uitableExtChans,'Data',obj.ext);
  end
  
  %set up the plot for the main output. Called by the class constructor.
  function InitializeMainPlot(obj)
    n_contours = 12;
    map = myMapRGB2(n_contours);
    obj.hPlotMain = contourf(obj.signal.data, n_contours);
    colormap(obj.hMainAxes, map)      
%    set(obj.hPlot,'DataSource', 'method.PlotData(1)');
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
    
    InitializeData(obj);

    InitializeTask(obj);
    
    obj.source.motors{1}.MoveTo(obj.PARAMS.start, obj.PARAMS.speed, 0, 0);
  end
  
  %start first sample. This code is executed before the scan loop starts
  function ScanFirst(obj)
    %start the data acquisition task
    obj.source.sampler.Start;
    obj.source.gate.OpenClockGate;
    obj.source.motors{1}.MoveTwoStep(obj.PARAMS.end, obj.PARAMS.start, obj.PARAMS.speed);
  end
  
  %This code is executed inside the scan loop. This is different from
  %ScanFirst for efficiency. It allows us to read data from ScanFirst
  %(making sure it is finished), then immediately start the second, and
  %process the first while the second is acquiring. It is also the place
  %to put code to save temporary files
  function ScanMiddle(obj)
      
    % Have to make sure movement is done.
    while obj.source.motors{1}.IsBusy
        pause(0.1);
    end
    obj.sample = obj.source.sampler.Read; %this will wait until the required points have been transferred (ie it will finish)
    obj.source.gate.CloseClockGate;
    %any other reading can happen next
    
    %no need to move motors
    
    %start the data acquisition task
    obj.source.sampler.Start;
    obj.source.gate.OpenClockGate;
    obj.source.motors{1}.MoveTwoStep(obj.PARAMS.end, obj.PARAMS.start, obj.PARAMS.speed);

    %process the previous results
    ProcessSample(obj);
    
    %no averaging
    %obj.AverageSample(obj);
    
    %plot results
    RefreshPlots(obj,obj.hPlotMain)
    RefreshPlots(obj,obj.hPlotRaw)
    UpdateDiagnostics(obj);
    drawnow
    %no saving
  end
  
  %This code executes after the scan loop. It should read but not start a
  %new scan. It should usually save the final results.
  function ScanLast(obj)
    while obj.source.motors{1}.IsBusy
        pause(0.1);
    end
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
    
    %no saving
    
  end
  
  %move the motors back to their zero positions. Clear the ADC tasks.
  function ScanCleanup(obj)
    obj.source.gate.CloseClockGate;
    obj.source.sampler.ClearTask;
    obj.source.motors{1}.MoveTo(0, obj.PARAMS.speed, 0, 0);
  end
%  
%   % @@@ Figure out what this is about.
%   %save the current result to a MAT file for storage.
%   function SaveResult(obj)
% %        setappdata(obj.handles.figure1,'result',obj.result);
% %    setappdata(obj.handles.figure1,'bin_count',obj.bin_count);
%   end
%   
%   %save intermediate results to a temp folder
%   function SaveTmpResult(obj)
%     obj.fileSystem.Save(obj.result);
% %    setappdata(obj.handles.figure1,'result',obj.result);
% %    setappdata(obj.handles.figure1,'bin_count',obj.bin_count);
%   end
%    
  function ProcessSampleSort(obj)
    %the easy thing
    
%    obj.sorted(:,:,1) = obj.sample(obj.ind_array1,1:obj.nShotsSorted);
%    obj.sorted(:,:,2) = obj.sample(obj.ind_array2,1:obj.nShotsSorted);

    obj.aux.igram = obj.sample(obj.ind_igram,:);
    obj.aux.hene_x = obj.sample(obj.ind_hene_x,:);
    obj.aux.hene_y = obj.sample(obj.ind_hene_y,:);

    [obj.position, obj.bin] = processPosition(obj.aux.hene_x,obj.aux.hene_y, obj.PARAMS.bin_zero,obj.PARAMS.start);

    for ii=1:obj.PARAMS.nShots
        jj = obj.bin(ii)-obj.PARAMS.bin_min+1;
        
        if (jj<=0) || (jj>obj.nBins), continue, end;
        obj.bin_data(:,jj) = obj.bin_data(:,jj) + obj.sample(:,ii);
        obj.bin_count(jj)  = obj.bin_count(jj)+1;
        
%        obj.bin_igram(jj)  = obj.bin_igram(:,jj) + obj.sorted(65,ii);
    end
%     for ii=1:obj.nChan
%         obj.bin_data(ii, 1:obj.nBins) = obj.bin_data(ii, 1:obj.nBins)./obj.bin_count(1:obj.nBins);
%     end
%     
    obj.sorted(1:obj.nPixelsPerArray, 1:obj.nBins, 1) = obj.bin_data(obj.ind_array1, 1:obj.nBins);
    obj.sorted(1:obj.nPixelsPerArray, 1:obj.nBins, 2) = obj.bin_data(obj.ind_array2, 1:obj.nBins);
    obj.bin_igram = obj.bin_data(obj.ind_igram, :);
    %obj.bin_igram = obj.bin_igram - mean(obj.bin_igram);
    
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

  function ProcessSampleBackAvg(obj)
    mean_bkgd = squeeze(mean(obj.signal.data, 2));
    obj.background.data = bsxfun(@plus, obj.background.data.*(obj.i_scan-1), mean_bkgd./obj.i_scan);
    %check this might not be right
    obj.background.std = bsxfun(@plus, sqrt(obj.background.std.^2.*(obj.i_scan-1)), (mean_bkgd.^2)./obj.i_scan);
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
    
    %So we first transpose the background from (nSignals x nPixels) to
    %(nPixels x nSignals). Reshape expands that to be (nPixels x 1 x
    %nSignals).
%    bg = reshape(obj.background.data',[obj.nPixelsPerArray 1 obj.nSignals]);
    
    % Background might have been saved with another method.  Make sure
    % the dimensions agree.
    if size(obj.background)~=[obj.nPixelsPerArray, obj.nSignals]
      obj.background = obj.background.';
    end
    
    %now bsxfun does the subtraction
%    obj.sorted = bsxfun(@minus,obj.sorted,obj.background);
    cnt = reshape(obj.bin_count, [1 obj.nBins 1]);
    a = reshape(obj.background.data, [obj.nPixelsPerArray, 1, obj.nSignals]);
%    b = reshape(cnt, [1, obj.PARAMS.nShots]);
    weighted_bkgd = bsxfun(@times, a, cnt);
    obj.signal.data = obj.sorted - weighted_bkgd;
 end

  function ProcessSampleAvg(obj)
    tmp = reshape(obj.bin_count, [1 obj.nBins 1]);
    
     obj.signal.data = bsxfun(@rdivide, obj.signal.data, tmp);
     obj.signal.data(isnan(obj.signal.data)) = 0;
%    temp = reshape(obj.bin_count,[1 obj.nBins 1]);
%    obj.signal.data = bsxfun(@rdivide,obj.sorted,temp);
%    obj.signal.igram = obj.bin_igram./obj.bin_count;
%    obj.signal.data = (obj.signal.data.*(obj.i_scan-1) + obj.sorted)./obj.i_scan;
%    obj.signal.std = squeeze(std(obj.sorted,0,2))';
  end
 
  function ProcessSampleResult(obj)
    %calculate the effective delta absorption (though we are plotting the
    %signals directly)
%    obj.result.data = obj.bin_data(1:32,:)./obj.bin_data(33:64,:);
    try
      obj.signal.igram = obj.bin_igram./obj.bin_count;
      [phase, t0_bin_shift, analysis] = phasing2dPP(obj.t_axis, obj.signal.igram);
    catch E
      warning('phasing failed');
      t0_bin_shift = 0;
      phase = 0;
%    rethrow E;
    end
    
    obj.result = construct2dPP;
    obj.result.phase = phase;
    obj.result.freq = obj.freq;
    obj.result.time = obj.t_axis;
    obj.result.bin = obj.b_axis;
    obj.result.zeropad = 1024;
    obj.result.PP = squeeze(obj.signal.data(:,:,1));
    obj.result.t0_bin = find(obj.result.bin==obj.PARAMS.bin_zero)-t0_bin_shift;
    try
      obj.result = absorptive2dPP(obj.result);
    catch E
      warning('absorptive2dPP failed');
      disp(E);
    end
  end
  
  function ProcessSampleNoise(obj)
    %calculate the signal from each shot for an estimate of the error
    obj.result.noise = 1000 * std(log10(obj.sorted(:,:,1)./obj.sorted(:,:,2)),0,2)';

    %the other option would be a propagation of error calculation but I
    %haven't worked through that yet. See wikipedia Propagation of
    %Uncertainty
  end
end

methods %public methods
  
    function out = get.Raw_data(obj)
        out = squeeze(mean(obj.signal.data, 2))';
    end
    
    function out = get.Noise(obj)
        out = obj.result.noise;
    end
  
    function out = get.nBins(obj)
      out = obj.PARAMS.bin_max - obj.PARAMS.bin_min+1;
    end
    
    function delete(obj)
        DeleteParameters(obj);
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

end



