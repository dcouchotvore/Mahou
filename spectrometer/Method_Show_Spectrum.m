classdef Method_Show_Spectrum < Method
%inherits from Method superclass

properties 
  %define specific values for Abstract properties listed in superclass
  
  %our result is a one dimensional spectrum of the intensity on the
  %detector (this should be some generic constructor...)
  result = struct('data',[],...
    'freq',[],...
    'noise',[]);
  %ScanIsRunning and ScanIsStopping are inherited
end

properties (Access = protected)
  sample;
  signal;
  background;
  PARAMS;
  source;
end

%
% public methods
%
methods
  function obj = Method_Show_Spectrum(FPAS,IO)
    %constructor
    
    obj.source.FPAS = FPAS; %is there a better way?
    obj.source.IO = IO;
    
    
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
  function InitializeParameters(obj,handles)
    
  end
  
  %initialize sample, signal, background, and result. Called by the class
  %constructor.
  function InitializeData(obj)
    
  end
    
  %set up the plot for the main output. Called by the class constructor.
  function InitializeMainPlot(obj,hAxesMain)
    %attach signal(1,:) and signal(2,:) to the main plot
  end
  
  %set up the ADC task(s)
  function InitializeTask(obj)
    %close gate
    obj.source.IO.CloseClockGate();
    
    %configure task
    obj.source.FPAS_Sample(0,obj.PARAMS); 
  end
  
  %initialize the data acquisition event and move motors to their
  %starting positions
  function ScanInitialize(obj,handles)
    %nothing required. Just leave motors where they are
    return
  end
  
  %start first sample. This code is executed before the scan loop starts
  function ScanFirst(obj,handles)
    %start the data acquisition task
    obj.source.FPAS_Sample(1,obj.PARAMS);
    obj.source.IO.OpenClockGate();
  end
  
  %This code is executed inside the scan loop. This is different from
  %ScanFirst for efficiency. It allows us to read data from ScanFirst
  %(making sure it is finished), then immediately start the second, and
  %process the first while the second is acquiring. It is also the place
  %to put code to save temporary files
  function ScanMiddle(obj,handles)
    obj.sample = obj.source.FPAS_Sample(2,obj.PARAMS); %this will wait until the required points have been transferred (ie it will finish)
    obj.source.IO.CloseClockGate();
    %any other reading can happen next
    
    %no need to move motors
    
    %start the data acquisition task
    obj.source.FPAS_Sample(1,obj.PARAMS);
    obj.source.IO.OpenClockGate();

    %process the previous results
    ProcessSample(obj);
    
    %no averaging
    %obj.AverageSample(obj);
    
    %plot results
    RefreshPlots(handles.axesMain)
    RefreshPlots(handles.axesRawData)
    
    %no saving
  end
  
  %This code executes after the scan loop. It should read but not start a
  %new scan. It should usually save the final results.
  function ScanLast(obj,handles)
    obj.sample = obj.source.FPAS_Sample(2,obj.PARAMS); %this will wait until the required points have been transferred (ie it will finish)
    source.IO.CloseClockGate();
    %any other reading can happen next
    
    %no need to move motors
    
    %process the previous results
    ProcessSample(obj);
    
    %no averaging
    %obj.AverageSample(obj);
    
    %plot results
    RefreshPlots(handles.axesMain)
    RefreshPlots(handles.axesRawData)
    
    %no saving
    
  end
  
  %move the motors back to their zero positions. Clear the ADC tasks.
  function ScanCleanup(obj,handles)
    
  end
  
  %acquire a background (might need to be public)
  function bg = BackgroundAcquire(PARAMS)
    
  end
  
  %save the current result to a MAT file for storage.
  function SaveResult(result)
    
  end
  
  %save intermediate results to a temp folder
  function SaveTmpResult(result)
    
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
