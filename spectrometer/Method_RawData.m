classdef Method_RawData < Method
    
    properties (SetAccess = protected)
        signal = struct('data',[],'std',[],'freq',[]);  
        background = struct('data',[],'std',[],'freq',[]);

        PARAMS = struct('nScans', 100);

        source = struct('sampler',[],'gate',[],'spect',[],'motors',[]);
    end
     
    methods
        
        function obj = Method_RawData
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
        end

        function Save(obj, filename)
            save(filename, obj.sample);
        end

    end
    
    methods (Access = protected)
        
        function InitializePlot(obj, handles)
            global scales;
            obj.hPlotMain = plot(handles.axesMain, scales.ch32, obj.sample.mean.pixels([1:32]), 'r');
        end

        function InitializeData(obj, ~)
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
        end
       
        function InitializeFreqAxis(obj)
            obj.freq = 1:32;
        end
  
        %set up the plot for the main output. Called by the class constructor.
        function InitializeMainPlot(obj)
            obj.hPlotMain = plot(handles.axesMain, obj.freq, obj.sample.mean.pixels([1:32]), 'r');   % ???
        end
        
        function InitializeTask(obj)
        end
        
        %initialize the data acquisition event and move motors to their
        %starting positions
        function ScanInitialize(obj)
        end

        %start first sample. This code is executed before the scan loop starts
        function ScanFirst(obj)
            obj.source.sampler.Start;
            obj.sample = obj.source.sampler.Read;
            ProcessSample(obj);

            %no averaging
            %obj.AverageSample(obj);

            %plot results
            RefreshPlots(obj,obj.hPlotMain)
            RefreshPlots(obj,obj.hPlotRaw)
            UpdateDiagnostics(obj);
            drawnow
        end

        %This code is executed inside the scan loop. This is different from
        %ScanFirst for efficiency. It allows us to read data from ScanFirst
        %(making sure it is finished), then immediately start the second, and
        %process the first while the second is acquiring. It is also the place
        %to put code to save temporary files 
        function ScanMiddle(obj)
            ScanFirst(obj);
        end

        %This code executes after the scan loop. It should read but not start a
        %new scan. It should save the final results.
        function ScanLast(obj)
            ScanFirst(obj);
        end

        %move the motors back to their zero positions. Clear the ADC tasks. 
        function ScanCleanup(obj)
        end

    end
end


            