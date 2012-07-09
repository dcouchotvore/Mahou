classdef IO_Interface < handle
    
    properties (SetAccess = private)
        libname;
        lib;
        lpt1_port;
    end
    
    methods
        
        function obj = IO_Interface
            obj.libname = 'inpoutx64';
            if ~libisloaded(obj.libname)
                obj.lib = loadlibrary(obj.libname);
                obj.lpt1_port = hex2dec('0378');
                CloseClockGate(obj);
            end
        end
        
        function delete(obj)
            if libisloaded(obj.libname)
                CloseClockGate(obj);
                unloadlibrary(obj.lib);
            end
        end

        function OpenClockGate(obj)
            obj.outputByte(obj.lpt1_port+2, bin2dec('00000110'));
        end
        
        function CloseClockGate(obj)
            obj.outputByte(obj.lpt1_port+2, bin2dec('00000111'));
        end
        
    end

    methods (Access = private)
        
        function outputByte(obj, port, data)
            calllib(obj.libname, 'DlPortWritePortUchar', port, data);
        end
        
    end
    
end
            
            
            