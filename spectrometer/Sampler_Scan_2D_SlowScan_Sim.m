classdef (Sealed) Sampler_Scan_2D_SlowScan_Sim < handle
    
    properties (SetAccess = private)
        nPixels;
        nExtInputs;
        nChan;
        nShots;
        nMaxChan;
        nChansPerBoard;
        nSampsPerChan;
        bufSizeInSamps;
        taskName;
        chanName;
        nDIChans;
        deviceName;
        lines;
        lib;
        ind;
        maxInd;
        initialized;
        hTask;
        timeout;
        
        options; %for simulation only
        fcns; %for simulation only
    end

    properties (Dependent)
    end
    
    methods (Access = private)
        
        function obj = Sampler_Scan_2D_SlowScan_Sim
          Initialize(obj);
        end
    end
    
    methods (Static)
      function singleObj = getInstance
        persistent localObj
        if isempty(localObj) || ~isvalid(localObj)
          localObj = Sampler_Scan_2D_SlowScan_Sim;
        end
        singleObj = localObj;
      end

    end
    
    methods
          
        function Initialize(obj)
            obj.options.path = 'c:\Users\INFRARED\Documents\GitHub\Mahou\spectrometer\test data processing\';
obj.options.inputfile_name = 'igram_inputfile';
obj.options.IR_voltage = 2; %volts on the detector
obj.options.IR_fwhm = 250; %in cm-1
obj.options.HeNe_modulation = 0.1; %+/- volts caused by interference
obj.options.HeNe_offset = 3; %offset voltage 
obj.options.HeNe_phase = 0; %degrees (I am not sure this is correct yet)
%obj.options.n_scans = 1;
obj.options.t_start = -500;%fs
obj.options.t_end = 1000; %fs
obj.options.fringes_per_shot = 0.15;
obj.options.laser_rep_rate = 5000;
obj.options.acceleration = 10; %mm/s^2
obj.options.spectrometer_n_pixels = 32;
obj.options.spectrometer_resolution = 30; %wavenumbers
            return
        end
        
        function ConfigureTask(obj,PARAMS)
            global fringeToFs fsToMm2Pass
          obj.nShots = PARAMS.nShots;
          obj.nChan = 80;
          obj.options.n_scans = PARAMS.nScans;
          obj.options.t_start = PARAMS.start;
          obj.options.t_end = PARAMS.end;
          obj.options.timing_error = 0;
          %speed should be fs/s, and this should give a number <0.25
          obj.options.fringes_per_shot = PARAMS.speed/fringeToFs/obj.options.laser_rep_rate;
            if obj.options.fringes_per_shot > 0.2,
                warning('SGRLAB:ParameterLimit',...
                    ['The number of fringes per shot should be less than' ...
                    ' 0.2 for correct counting, currently %f\n'],...
                    obj.options.fringes_per_shot);
            end
            obj.options.acceleration = PARAMS.acceleration*fsToMm2Pass;
            fprintf(1,'acceleration (mm/s^2) = %f\n',obj.options.acceleration);

            old_wd = pwd;
            cd(obj.options.path);
            obj.fcns = initializeSimulation(obj.options);
            cd(old_wd);
        end
        
        function Start(obj)
          return
        end

        % Finish up and collect data
        function result = Read(obj)
            drawnow
            [~,~,result] = simulateData(obj.fcns,obj.options);

        end
        
        function ClearTask(obj)
          return
        end

        
    end
    
    methods (Access = protected)
 
    end %protected methods

end %classdef
