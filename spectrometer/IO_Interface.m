classdef IO_Interface < handle
    
    properties (SetAccess = private)
        dio;
    end
    
    methods
        
        function obj = IO_Interface
            obj.dio = digitalio('nidaq', 'Dev2');
            addline(obj.dio, 7, 1, 'out');      % Port 1 bit 7
        end
        
        function delete(obj)
            CloseClockGate(obj);
            close(obj.dio);
        end

        function OpenClockGate(obj)
            putvalue(obj.dio.Lines(1), 1);
        end
        
        function CloseClockGate(obj)
            putvalue(obj.dio.Lines(1), 0);
        end
        
    end
    
end
            
            
            