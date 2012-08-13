classdef (Sealed) Sampler_test < handle
    
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
    end

    properties (Dependent)
    end
    
    methods (Access = private)
        
        function obj = Sampler_test
          return
        end
    end
    
    methods (Static)
      function singleObj = getInstance
        persistent localObj
        if isempty(localObj) || ~isvalid(localObj)
          localObj = Sampler_test;
        end
        singleObj = localObj;
      end

    end
    
    methods
          
        function Initialize(obj)
            return
        end
        
        function ConfigureTask(obj,PARAMS)
          obj.nShots = PARAMS.nShots;
          obj.nChan = 80;
        end
        
        function Start(obj)
          return
        end

        % Finish up and collect data
        function result = Read(obj)
          result = (0.005*randn(obj.nChan,obj.nShots)+0.5)*2^16;
          drawnow
          pause(0.3)
        end
        
        function ClearTask(obj)
          return
        end

        
    end
    
end
