classdef Method < handle
  
  %
  %    here are the properties that every data acq method must define
  %
  
  %the public properties
  properties (Abstract, SetAccess = protected)
    %the final spectrum which will be saved to disk
    result;
  end
  
  %the properties not visible outside the class or subclass
  properties (Abstract, SetAccess = protected) 
    %the raw data block(s) straight from ADC(s) (the FPAS for example).
    %This will probably be the same for most methods. 
    sample; 
    
   
    %the sorted data assigned to roles (signal / ref, pumped / unpumped) but still one value per laser
    %shot. This will be different for every method.
    sorted;
    
    %The chopper, IR_intererogram, HeNe x, HeNe y, etc
    aux;
    
    %average each signal and calculate noise for each signal
    signal; 
    nSignals;
        
    %the background which is subtracted from each signal after sorting. The
    %background must match the structure of the data in <sorted>. 
    background; 
    
    %a struct of all the parameters describing the data acquisition event
    PARAMS;
    
    %a struct array of all the sources of data used by the method
    %a name and a function handle? E.g. source.name = 'MCT-array',
    %source.fxn = @FPAS_Sample (for real data) or 
    % source.fxn = @Simulate_FPAS (for fake data)
    source; 
    
    %the frequency axis (eventually comes from the spectrometer)
    freq;
    
    % Number of current scan
    i_scan;
  end

  %here are the properties that all methods share. 

  %booleans to communicate about the state of a scan. When
  properties 
    ScanIsRunning = false;
    ScanIsStopping = false;

    %handles to the plots so we can refresh them
    hPlotMain;
    hPlotRaw;
    
    hMainAxes;
    hParamsPanel;
    hRawDataAxes;
    hDiagnosticsPanel;
    handles; %should be able to do this better but for now try this

    noiseGain = 1;
  end

  %These are all calculated from other data, and are not stored 
  %every specific method must define a get method (no set method needed)
  properties (Abstract,Dependent, SetAccess = protected)
    Raw_data;
    Diagnostic_data;
    Noise;
  end
  
  %
  %     here are the methods that every data acq method must define
  %
  methods (Abstract) %public

  end
  
  methods (Abstract, Access = protected)
    %initialize sample, signal, background, and result. Called by the class
    %constructor.
    InitializeData(obj);
    
    %read the spectrometer and set the x-axis of the plots
    InitializeFreqAxis(obj);
    
    %set up the plot for the main output. Called by the class constructor.
    InitializeMainPlot(obj,hMainAxes);
    
    %set up the ADC task(s)
    InitializeTask(obj);
    
    %initialize the data acquisition event and move motors to their
    %starting positions
    ScanInitialize(obj);
    
    %start first sample. This code is executed before the scan loop starts
    ScanFirst(obj);
    
    %This code is executed inside the scan loop. This is different from
    %ScanFirst for efficiency. It allows us to read data from ScanFirst
    %(making sure it is finished), then immediately start the second, and
    %process the first while the second is acquiring. It is also the place
    %to put code to save temporary files 
    ScanMiddle(obj);
    
    %This code executes after the scan loop. It should read but not start a
    %new scan. It should save the final results.
    ScanLast(obj);
    
    %move the motors back to their zero positions. Clear the ADC tasks. 
    ScanCleanup(obj);
    
    %save the current result to a MAT file for storage.
    SaveResult(result);
    
    %save intermediate results to a temp folder
    SaveTmpResult(result);
    
    %the entire 
    ProcessSampleSort(obj);
    
    ProcessSampleAvg(obj);
    
    ProcessSampleSubtBack(obj);
    
    ProcessSampleResult(obj);
    
    ProcessSampleNoise(obj);
    
    ProcessSampleBackAvg(obj);
  end
  
  %
  %     here are the methods that all data acq methods share (not
  %     abstract)
  %
  %the public
  methods
    function ScanStop(obj)
      obj.ScanIsStopping = true;
    end
    
    %untested -- probably screwed up
    function InitializeRawDataPlot(obj)
      
      n_plots = size(obj.Raw_data,1);
      hold(obj.hRawDataAxes, 'off');
      obj.hPlotRaw = zeros(1,n_plots);
      for i = 1:n_plots
        % The Raw Data plot is the same for every method.
        obj.hPlotRaw(i) = plot(obj.hRawDataAxes, 1:obj.nPixelsPerArray, obj.Raw_data(i,:));
        set(obj.hPlotRaw(i),'Color',[mod(1-(i-1)*0.1,1) 0 0]);
        set(obj.hPlotRaw(i),'YDataSource',['obj.Raw_data(',num2str(i),',:)']);
        hold(obj.hRawDataAxes, 'on');
      end        
      
      %plot noise
      i=i+1;
      obj.hPlotRaw(i) = plot(obj.hRawDataAxes, 1:obj.nPixelsPerArray, obj.Noise.*obj.noiseGain, 'b');
      set(obj.hPlotRaw(i),'YDataSource','obj.Noise.*obj.noiseGain');
      set(obj.hRawDataAxes,'XLim',[1 obj.nPixelsPerArray],'Ylim',[0 2^16*1.05]);
      
%       % The Raw Data plot is the same for every method.
%       hRawPlots(1) = plot(hAxesRawData, obj.freq, obj.Raw_data(1,:), 'r');
%       set(hRawPlots(1),'XDataSource', 'obj.freq', 'YDataSource','obj.Raw_data(1,:)');
%       hold(handles.axesRawData, 'on');
%       hRawPlots(2) = plot(hAxesRawData, obj.freq, obj.Raw_data(2,:), 'g');
%       set(hRawPlots(2),'XDataSource', 'obj.freq', 'YDataSource','obj.Raw_data(2,:)');
%       hRawPlots(3) = plot(hAxesRawData, obj.freq, obj.Noise(1, :), 'b');
%       set(hRawPlots(3),'XDataSource', 'obj.freq', 'YDataSource','obj.Noise');
%       hold(hAxesRawData, 'off');
%       set(hAxesRawData, 'XLim', [obj.freq(1) obj.freq(end)]);
    end
    
    %untested
    function Initialize(obj)
      
      InitializeFreqAxis(obj);

      InitializeParameters(obj);

      ReadParameters(obj);
      
      InitializeData(obj);
      
      InitializeMainPlot(obj);
      
      InitializeRawDataPlot(obj);
      
      InitializeDiagnostics(obj);
    end
    
    %untested
    function InitializeDiagnostics(obj)
      %setup the panel for this method
      set(obj.handles.textNoise,'String',sprintf('%5.3f',mean(obj.Noise)));
    end
    
    %untested
    function UpdateDiagnostics(obj)
      %mean noise in mOD
      set(obj.handles.textNoise,'String',sprintf('%5.3f',mean(obj.Noise)));
      
      %noise in %
      
      
    end
    
    %untested (should work for all axes that have XDataSource and
    %YDataSource properly configured
    function RefreshPlots(obj,hPlots,hAutoScaleToggle)
      refreshdata(hPlots, 'caller');
    end
    
    %untested
    function RefreshDiagnostics(obj,hDiagnosticsUI)
      %set each text box to needed value
    end
  
    %untested 
    %By defining this as ~Abstract, all data acquisition methods must
    %follow this essential recipe for acquiring their data. Each individual
    %method customizes the behavior by defining specific actions for these
    %abstract operations
    function Scan(obj)
      
      obj.ScanIsRunning = true;

      ScanInitialize(obj);
      
      obj.i_scan = 1;
      
      set(obj.handles.textScanNumber,'String',sprintf('Scan # %i',obj.i_scan));
      
      drawnow;

      ScanFirst(obj);
      
      while obj.i_scan ~= obj.PARAMS.nScans && obj.ScanIsStopping == false

        obj.i_scan = obj.i_scan + 1;
        
        set(obj.handles.textScanNumber,'String',sprintf('Scan # %i',obj.i_scan));
        
        drawnow;

        ScanMiddle(obj);

        SaveTmpResult(obj);
        
      end
      
      set(obj.handles.textScanNumber,'String',sprintf('Scan # %i',obj.i_scan));
      
      drawnow;
      
      obj.ScanLast;

      SaveResult(obj);
      
      obj.ScanCleanup;

      obj.ScanIsRunning = false;

      obj.ScanIsStopping = false;
    
    end
    
  function BackgroundReset(obj)
    obj.background.data = zeros(size(obj.background.data));
    obj.background.std = zeros(size(obj.background.std));
  end
    
  %acquire a background (might need to be public)
  function BackgroundAcquire(obj)
    obj.ScanIsRunning = true;
    obj.ScanIsStopping = false;
    obj.BackgroundReset;
    obj.ReadParameters;
    obj.InitializeTask;
    
    for ni_scan = 1:10            % @@@ is there some reason we can't assign obj.i_scan directly?
      obj.i_scan = ni_scan;
      set(obj.handles.textScanNumber,'String',sprintf('Scan # %i',obj.i_scan));
      drawnow;

      obj.source.sampler.Start;
      obj.source.gate.OpenClockGate;
      obj.sample = obj.source.sampler.Read;
      obj.source.gate.CloseClockGate;

      obj.ProcessSampleSort;
      obj.ProcessSampleAvg;
      obj.ProcessSampleBackAvg;

    end
    obj.source.sampler.ClearTask;
    obj.ScanIsRunning = false;

  end
  end
  
  %private methods
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
    
    %update the handles  -- @@@ Seems to be returning the wrong handle set
    %sometimes.
    obj.handles = guihandles(obj.handles.figure1);
 
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

    function ProcessSample(obj)
      %sort data
      ProcessSampleSort(obj);
      
      %remove background
      ProcessSampleSubtBack(obj);

      %avg signals
      ProcessSampleAvg(obj);
    
      %calc result
      ProcessSampleResult(obj);
      
      %calc noise (at least an estimate)
      ProcessSampleNoise(obj);
    end

    function result = TimeFsToBin(time, zerobin)
        result = round(time/fringeToFs)+zerobin;
    end

  end
  
end
