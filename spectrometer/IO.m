classdef IO < handle
    
    properties (SetAccess = private, Hidden = true)
        libname;
        lpt1_port;
    end
    
    methods
        
        function obj = IO
            obj.libname = 'inpoutx64';
            if ~islibloaded(obj.libname)
                loadlibrary(obj.libname);
                obj.lpt1_port = hex2dec('0378');
                CloseClockGate(obj);
            end
        end
        
        function delete(obj)
            if islibloaded(obj.libname)
                CloseClockGate(obj);
                unloadlibrary(obj.libname);
            end
        end

        function OpenClockGate(obj)
            outputByte(obj.lpt1_port+2, bin2dec('00000110'));
        end
        
        function CloseClockGate(obj)
            outputByte(obj.lpt1_port+2, bin2dec('00000111'));
        end
        
    end

    methods (Access = private)
        
        function outputByte(obj, port, data)
            calllib(obj.libname, 'DlPortWritePortUchar', port, data);
        end
        
    end
    
end
            
            
            