classdef Method < handle
  
  %
  %    here are the properties that every data acq method must define
  %
  
  %the public properties
  properties (Abstract)
    %the final spectrum which will be saved to disk
    result;
  end
  
  %the properties not visible outside the class or subclass
  properties (Abstract, Access = protected)
    %the raw data block(s) straight from ADC(s) as a cell array
    sample; 
    
    %the sorted data assigned to roles (signal, ref, pumped, unpumped,
    %IR_intererogram, HeNe x, HeNe y, etc) but still one value per stage
    %position
    signal; 
        
    %the background which is subtracted from each signal after sorting
    background; 
    
    %a struct of all the parameters describing the data acquisition event
    PARAMS;
    
    %a struct array of all the sources of data used by the method
    %a name and a function handle? E.g. source.name = 'MCT-array',
    %source.fxn = @FPAS_Sample (for real data) or 
    % source.fxn = @Simulate_FPAS (for fake data)
    source; 
    
  end

  %here are the properties that all methods share. 

  %booleans to communicate about the state of a scan. When
  properties 
    ScanIsRunning = false;
    ScanIsStopping = false;
  end

  %These are all calculated from other data, and are not stored 
  %every specific method must define a get method (no set method needed)
  properties (Dependent, Access = protected)
    Raw_data;
    Diagnostic_data;
    Noise;
  end
  
  %
  %     here are the methods that every data acq method must define
  %
  methods (Abstract, Access = protected)
    %populate a pane with the appropriate UI elements and default values
    %consistent with the PARAMS for this method. Should be called by the
    %class constructor.
    InitializeParameters(obj,handles);
    
    %initialize sample, signal, background, and result. Called by the class
    %constructor.
    InitializeData(obj);
    
    %set up the plot for the main output. Called by the class constructor.
    InitializeMainPlot(obj,hAxesMain);
    
    %set up the ADC task(s)
    InitializeTask(obj);
    
    %initialize the data acquisition event and move motors to their
    %starting positions
    ScanInitialize(obj,handles);
    
    %start first sample. This code is executed before the scan loop starts
    ScanFirst(obj,handles);
    
    %This code is executed inside the scan loop. This is different from
    %ScanFirst for efficiency. It allows us to read data from ScanFirst
    %(making sure it is finished), then immediately start the second, and
    %process the first while the second is acquiring. It is also the place
    %to put code to save temporary files 
    ScanMiddle(obj,handles);
    
    %This code executes after the scan loop. It should read but not start a
    %new scan. It should save the final results.
    ScanLast(obj,handles);
    
    %move the motors back to their zero positions. Clear the ADC tasks. 
    ScanCleanup(obj,handles);
    
    %acquire a background (might need to be public)
    bg = BackgroundAcquire(PARAMS);
    
    %save the current result to a MAT file for storage.
    SaveResult(result);
    
    %save intermediate results to a temp folder
    SaveTmpResult(result);
    
  end
  
  %
  %     here are the methods that all data acq methods share
  %
  %the public
  methods
    function ScanStop(obj)
      obj.ScanIsStopping = true;
    end
  end
  %the private
  methods (Access = protected)
    
    %untested -- probably screwed up
    function hRawPlots = InitializeRawDataPlot(obj,hAxesRawData,scale,Raw_data,Noise)
      % The Raw Data plot is the same for every method.
      hRawPlots(1) = plot(hAxesRawData, scale, Raw_data(1,:), 'r');
      set(hRawPlots(1),'XDataSource', 'scale', 'YDataSource','obj.Raw_data(1,:)');
      hold(handles.axesRawData, 'on');
      hRawPlots(2) = plot(hAxesRawData, scale, Raw_data(2,:), 'g');
      set(hRawPlots(2),'XDataSource', 'scale', 'YDataSource','obj.Raw_data(2,:)');
      hRawPlots(3) = plot(hAxesRawData, scale, Noise(1, :), 'b');
      set(hRawPlots(3),'XDataSource', 'scale', 'YDataSource','obj.Noise');
      hold(handles.axesRawData, 'off');
      set(handles.axesRawData, 'XLim', [1, length(Raw_data)]);
    end
    
    %untested
    function hDiagnosticsUI = InitializeDiagnostics(obj,hDiagnosticsPanel)
      %setup the panel for this method
    end
    
    %untested
    function hDiagnosticsUI = UpdateDiagnostics(obj,hDiagnosticsPanel,Diagnostic_data)
      %mean noise in mOD
      
      %noise in %
      
      
    end
    
    %untested (should work for all axes that have XDataSource and
    %YDataSource properly configured
    function RefreshPlots(hAxes)
      refreshdata(hAxes, 'caller');
    end
    
    %untested
    function RefreshDiagnostics(hDiagnosticsUI)
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
      
      ScanFirst(obj);
      
      while i_scan ~= obj.PARAMS.n_scans && obj.ScanIsStopping == false

        ScanMiddle(obj);
      
      end
      
      ScanLast(obj);

      ScanCleanup(obj);

      obj.ScanIsRunning = false;

      obj.ScanIsStopping = false;
    
    end
  end
  
end
