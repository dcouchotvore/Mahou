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
    %populate a pane with the appropriate UI elements and default values
    %consistent with the PARAMS for this method. Should be called by the
    %class constructor.
    InitializeParameters(obj);
    
    %read the parameters from the panel into a struct obj.PARAMS
    ReadParameters(obj);
    
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
    
    %acquire a background (might need to be public)
    BackgroundAcquire(obj);
    
    %save the current result to a MAT file for storage.
    SaveResult(result);
    
    %save intermediate results to a temp folder
    SaveTmpResult(result);
    
    %the entire 
    ProcessSampleSort(obj);
    
    ProcessSampleAvg(obj);
    
    ProcessSampleSubtBack(obj);
    
    ProcessSampleResult(obj);
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
        set(obj.hPlotRaw(i),'Color',[mod(1-(i-1)*0.2,1) 0 0]);
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
      
      i_scan = 1;
      
      set(obj.handles.textScanNumber,'String',num2str(i_scan));
      
      drawnow;

      ScanFirst(obj);
      
      while i_scan ~= obj.PARAMS.nScans && obj.ScanIsStopping == false

        i_scan = i_scan + 1;
        
        set(obj.handles.textScanNumber,'String',num2str(i_scan));
        
        drawnow;

        ScanMiddle(obj);

      end
      
      set(obj.handles.textScanNumber,'String',num2str(i_scan));
      
      drawnow;
      
      obj.ScanLast;

      obj.ScanCleanup;

      obj.ScanIsRunning = false;

      obj.ScanIsStopping = false;
    
    end
  end
  
  %private methods
  methods (Access = protected)
  
    function ProcessSample(obj)
      %sort data
      ProcessSampleSort(obj);
      
      %avg signals
      ProcessSampleAvg(obj);

      %remove background
      ProcessSampleSubtBack(obj);
    
      %calc result
      ProcessSampleResult(obj);
    end

  end
  
end
