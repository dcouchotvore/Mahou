classdef Sampler < handle
  
  properties (SetAccess = protected)
    nPixels;
    nExtInputs;
    nChan;
    nShots;
    initialized;

    options;
    fcns;
    
    LASER;
  end
  
  methods (Access = protected)
    function obj = Sampler(laser);
      LASER = laser;
      obj.initialized = 0;
      LASER = Laser;
    end
  end
  
  methods (Access = protected, Abstract = true))

    function Initialize(obj); end;
    function ConfigureTask(obj, PARAMS); end;
    function Start(obj); end;
    function result = Read(obj); end;
    function ClearTask(obj); end;
    
  end
    
end


    