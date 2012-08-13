classdef Method_Show_Spectrum < Method
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
  signal = struct('data',[],'std',[],'freq',[]);  
  background = struct('data',[],'std',[],'freq',[]);
  
  PARAMS = struct('nShots',500,'nScans',-1);
  
  source = struct('sampler',[],'gate',[],'spect',[],'motors',[]);

  %TODO: split source to separate objects
%   sampler;
%   gate;
%   spect;
%   motors;
  
  freq;
  
  nSignals = 2;
  nArrays = 2;
  nPixelsPerArray = 32;
  nPixels = 64;
  nExtInputs = 16;
  nChan = 80;
  ind_array1 = 1:32;
  ind_array2 = 33:64;
  ind_igram = 1;
  ind_hene_x = 15;
  ind_hene_y = 16;
  
  nShotsSorted;

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
  function obj = Method_Show_Spectrum(sampler,gate,spect,motors,handles,hParamsPanel,hMainAxes,hRawDataAxes,hDiagnosticsPanel)
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
  end
  
  %inherited public methods:
  %ScanStop
end

%
% private (protected) methods
%
methods (Access = protected)
  %populate a pane with the appropriate UI elements and default values
  %consistent with the PARAMS for this method. Should be called by the
  %class constructor.
  function InitializeParameters(obj)
    disp('init parameter window');

    %get a cell array of the names of the parameters
    names = fieldnames(obj.PARAMS);
    %how many parameters are there
    n_params = length(names);
    
    temp = get(obj.hParamsPanel,'Position');
    y_origin = temp(4); %height of Panel
    
    x_pos = 2;
    y_pos = -2;
    width = 12; %35;
    height = 1.83;%25;
    x_offset = 1;
    y_offset = 0.25;
    %loop over parameters setting a text box and an edit box for each
    for i = 1:n_params

      %make the text box
      uicontrol('Parent', obj.hParamsPanel,...
        'Style','text','Tag',['text' names{i}],...
        'String',names{i},...
        'Units','Characters',...
        'Position',[x_pos y_pos+y_origin-i*(y_offset+height) width height])

      %make the edit box
      uicontrol('Parent', obj.hParamsPanel,...
        'Style','edit','Tag',['edit' names{i}],...
        'String',obj.PARAMS.(names{i}),... %this is a dynamic field name structure.(expression) where expression returns a string
        'Units','Characters',...
        'Position',[x_pos+x_offset+width y_pos+y_origin-i*(y_offset+height) width height])
    
    end
    
    %update the handles
    obj.handles = guihandles(gcf);
 
  end
  
  function ReadParameters(obj)

    field = fieldnames(obj.PARAMS);
    n_fields = length(field);
    for i = 1:n_fields
      obj.PARAMS.(field{i}) = str2double(get(obj.handles.(['edit' field{i}]), 'String'));
    end 
    %obj.PARAMS.nScans = str2double(get(obj.handles.editnScans, 'String'));
    %obj.PARAMS.nShots = str2double(get(obj.handles.editnShots, 'String'));
    %obj.PARAMS.start  = str2double(get(obj.handles.editStart, 'String'));
    %obj.PARAMS.stop   = str2double(get(obj.handles.editStop, 'String'));
    %obj.PARAMS.speed  = str2double(get(obj.handles.editSpeed, 'String'));

  end
  
  function DeleteParameters(obj)
    %get a cell array of the names of the parameters
    names = fieldnames(obj.PARAMS);
    %how many parameters are there
    n_params = length(names);

    for i = 1:n_params
        h = findobj(obj.hParamsPanel,'tag',['text' names{i}]);
        delete(h);
    end
    for i = 1:n_params
        h = findobj(obj.hParamsPanel,'tag',['edit' names{i}]);
        delete(h);
    end
  end
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
    obj.result.data = zeros(1,obj.nPixelsPerArray);
    obj.result.noise = zeros(1,obj.nPixelsPerArray);

    obj.aux.igram = zeros(1,obj.PARAMS.nShots);
    obj.aux.hene_x = zeros(1,obj.PARAMS.nShots);
    obj.aux.hene_y = zeros(1,obj.PARAMS.nShots);
    
  end
    
  function InitializeFreqAxis(obj)
    obj.freq = 1:32;
  end
  
  %set up the plot for the main output. Called by the class constructor.
  function InitializeMainPlot(obj)
    %attach signal.data(1,:) and signal.data(2,:) to the main plot
    obj.hPlotMain = zeros(1,obj.nSignals);
    for i = 1:obj.nSignals
      obj.hPlotMain(i) = plot(obj.hMainAxes,obj.freq,obj.signal.data(1,:));
      set(obj.hPlotMain(i),'XDataSource','obj.freq','YDataSource','obj.signal.data(1,:)')
    end
    set(obj.hMainAxes,'Xlim',[obj.freq(1) obj.freq(end)]);
    
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
    
    %no saving
    
  end
  
  %move the motors back to their zero positions. Clear the ADC tasks.
  function ScanCleanup(obj)
    obj.source.gate.CloseClockGate;
    
    %no need to move motors back to zero
  end
  
  %acquire a background (might need to be public)
  function BackgroundAcquire(obj)
    
  end
  
  %save the current result to a MAT file for storage.
  function SaveResult(obj)
    
  end
  
  %save intermediate results to a temp folder
  function SaveTmpResult(obj)
    
  end
   
  function ProcessSampleSort(obj)
    %the easy thing
    
    obj.sorted(:,:,1) = obj.sample(obj.ind_array1,1:obj.nShotsSorted);
    obj.sorted(:,:,2) = obj.sample(obj.ind_array2,1:obj.nShotsSorted);

    obj.aux.igram = obj.sample(obj.ind_igram);
    obj.aux.hene_x = obj.sample(obj.ind_hene_x);
    obj.aux.hene_y = obj.sample(obj.ind_hene_y);

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
  end
  
  function ProcessSampleSubtBack(obj)
    obj.signal.data = obj.signal.data - obj.background.data;
    obj.signal.std = sqrt(obj.signal.std.^2 + obj.background.std.^2);
  end

  function ProcessSampleResult(obj)
    %for show spectrum the two arrays are the direct result
    obj.result.data = obj.signal.data;

    %calculate the signal from each shot for an estimate of the error
    obj.result.noise = 1000 * std(log10(obj.sorted(:,:,1)./obj.sorted(:,:,2)),0,2)';

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


