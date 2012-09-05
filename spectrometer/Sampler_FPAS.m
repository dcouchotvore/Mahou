classdef (Sealed) Sampler_FPAS < handle
%this class is implemented so there can be only one instance at a time. See 
%http://www.mathworks.com/help/techdoc/matlab_oop/bru6n2g.html for details.
%Note that the way to call the class is to call FPAS =
%Sampler_FPAS.getInstance, (instead of FPAS = Sampler_FPAS).

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
        nSamplesPerSecond;
        timeout;
        COMPortID = 'COM2';
        COMPort;
        COMPortOpts = struct('BaudRate',9600,...
          'Parity','none',...
          'DataBit',8,...
          'StopBits',1,...
          'FlowControl','software');
  

    end
    
    %make the constructor private
    methods (Access = private)

      function obj = Sampler_FPAS

        LoadNIConstants;
        Initialize(obj);
      end
      
    end
     
    %hold the instance as a persistent variable
    methods (Static)
      function singleObj = getInstance
        persistent localObj
        if isempty(localObj) || ~isvalid(localObj)
          localObj = Sampler_FPAS;
        end
        singleObj = localObj;
      end
    end
    
    methods
        
        function Initialize(obj)
            
            %propteries of the array detector
            obj.nPixels = 64;
            obj.nExtInputs = 16;
            obj.nMaxChan = 256; %the number of channels written to the FIFO buffer in the FPAS
            obj.nChansPerBoard = 32; %has to do with the number of channels on the boards going to the FIFO
            obj.deviceName = 'Dev1'; %determined by NI-MAX
            obj.lines = {'Dev1/line0:31'};
            obj.taskName = '';
            obj.chanName = {''};
            obj.nSamplesPerSecond = 5000;
            obj.timeout = 1;
            
            %% load library
            obj.lib = 'myni';	% library alias
            if ~libisloaded(obj.lib)
                disp('Matlab: Load nicaiu.dll')
                loadlibrary('nicaiu.dll','C:\Program Files (x86)\National Instruments\NI-DAQ\DAQmx ANSI C Dev\include\nidaqmx.h','alias',obj.lib);
                %if you do NOT have nicaiu.dll and nidaqmx.h
                %in your Matlab path,add full pathnames or copy the files.
                %libfunctions(FPAS.lib,'-full') % use this to show the... 
                %libfunctionsview(FPAS.lib)     % included function
            end
            %disp('Matlab: nicaiu.dll loaded')

            % %% load all DAQmx constants
            % if ~exist('flag_NIconstants_defined','var') || ~flag_NIconstants_defined
            %     NIconstants;    
            % end
            %disp('done')

            obj.nChan = obj.nPixels + obj.nExtInputs;

            %set up the index for swizzling the data
            obj.ind = [];
            for ii = 1:ceil(obj.nChan/obj.nChansPerBoard)
              obj.ind = [obj.ind,[1:2:15 2:2:16; 17:2:31 18:2:32]+(ii-1)*32];
            end
            obj.ind = obj.ind(:);

            %how many channels do you need to keep to unravel all the data correctly
            obj.maxInd = ceil(obj.nChan/obj.nChansPerBoard)*obj.nChansPerBoard;

            %try to communicate to hardware(both the DIO board and the COM
            %port). If succeeds initialized = 1. Else initialized = 0
            %(simulation mode)
            obj.initialized = 0;
            try 
            %% reset device
                DAQmxResetDevice(obj.lib,obj.deviceName);
                
                %try the COMPort
                InitializeCOMPort(obj);
                
                %
                obj.initialized = 1;
            catch E
                disp(E);
                warning('Spectrometer:FPAS', 'FPAS system not found.  Entering simulation mode.');
            end
        end
        
        function ConfigureTask(obj,PARAMS)
          global NICONST
          obj.nShots = PARAMS.nShots;
          obj.nSampsPerChan = obj.nMaxChan/2*obj.nShots+1; %nChan/2+1; %total number of points to acquire #Ch*#scans (where scans is NI language for shots)
          obj.timeout = ceil(obj.nShots/obj.nSamplesPerSecond+0.5);
          if obj.initialized
            [obj.hTask,obj.nDIChans] = DAQmxCreateDIChan(obj.lib,obj.lines,NICONST.DAQmx_Val_ChanForAllLines,'',{''});
            %here obj.nDIChans is the number of digital input channels, i.e. just 1
            
            %% configure timing
            
            sampleMode = NICONST.DAQmx_Val_FiniteSamps;
            sampleClkRate = 10e6;%10 MHz
            sampleClkOutputTerm = '/Dev1/PFI4'; %note leading front slash. Why needed here???
            sampleClkPulsePolarity = NICONST.DAQmx_Val_ActiveHigh;
            pauseWhen = NICONST.DAQmx_Val_High;
            readyEventActiveLevel = NICONST.DAQmx_Val_ActiveHigh;
            
            DAQmxCfgBurstHandshakingTimingExportClock(obj.lib, obj.hTask,...
              sampleMode,obj.nSampsPerChan,sampleClkRate,sampleClkOutputTerm,...
              sampleClkPulsePolarity,pauseWhen,readyEventActiveLevel);
            
            
            %% set input buffer size
            obj.bufSizeInSamps = obj.nSampsPerChan*obj.nDIChans;
            DAQmxCfgInputBuffer(obj.lib,obj.hTask,obj.bufSizeInSamps);

            %% set DMA transfer
            DAQmxSetDIDataXferMech(obj.lib,obj.hTask,obj.chanName,NICONST.DAQmx_Val_DMA);
            
            %% commit (make everything as ready to go as it can be)
            DAQmxTaskControl(obj.lib,obj.hTask,NICONST.DAQmx_Val_Task_Commit);

          end
          
        end
        
        function Start(obj)
            %global NICONST;
            if obj.initialized
    
                %% start the task
                DAQmxStartTask(obj.lib, obj.hTask);
            end
        end

        % Finish up and collect data
        function result = Read(obj)
            global NICONST
            
            if obj.initialized

                % read 
                fillMode = NICONST.DAQmx_Val_GroupByChannel; % Group by Channel
                %fillMode = NICONST.DAQmx_Val_GroupByScanNumber; % I think this doesn't matter when only 1 channel

          
                [portdata,sampsPerChanRead] = DAQmxReadDigitalU32(obj.lib,obj.hTask,obj.nDIChans,obj.nSampsPerChan,obj.timeout,fillMode,obj.bufSizeInSamps);

                %do any error checking on sampsPerChanRead here?
                if sampsPerChanRead ~= obj.nSampsPerChan
                  warning('SGRLAB:UnderConstruction','maybe did not get all the data??? debug nSampsPerChan and sampsPerChanRead.');
                end
                
                %% stop
                DAQmxStopTask(obj.lib,obj.hTask);

                %% swizzle data (could be optimized for memory and speed)

                %throw away first point because it is empty
                hm = portdata(2:end);

                %throw away as many points as we can without losing information
                hm = reshape(hm,obj.nMaxChan/2,obj.nShots);
                hm = hm(1:obj.maxInd/2,:);

                %flatten again
                hm = hm(:); 

                %convert each 32bit number to two 16bit numbers
                hmm = typecast(hm,'uint16');
                hmm = reshape(hmm,obj.maxInd,obj.nShots);

                %use ind to sort the data
                result = double(hmm(obj.ind,1:obj.nShots));
                result = result(1:obj.nChan,:);

            else
              result = zeros(obj.nChan, obj.nShots);
            end
           
        end
        
        function ClearTask(obj)
          %% clear
          DAQmxClearTask(obj.lib,obj.hTask);
          
        end

        %
        % COM TASKS GO HERE
        %
        function InitializeCOMPort(obj)
          obj.COMPort = instrfind('Type','serial','Port',obj.COMPortID,'Tag','');
          
          
          if isempty(obj.COMPort)
            obj.COMPort = serial(obj.COMPortID,'BaudRate',obj.COMPortOpts.BaudRate);
          else
            fclose(obj.COMPort);
            obj.COMPort = obj.COMPort(1);
          end

          fopen(obj.COMPort); %open port
          set(obj.COMPort,obj.COMPortOpts);

        end
        
        function CloseCOMPort(obj)
          fclose(obj.COMPort);
          delete(obj.COMPort);
          obj.COMPort = [];
        end
        
        function SetGain(obj,chan,val)
          CHAN_MAX = 255;
          CHAN_MIN = 0;
          VAL_MAX = 7;
          VAL_MIN = 0;
          
          %make sure input is a number
          if ~isnumeric(chan)
            warning('SGRLAB:FPAS','chan = %s which is not numeric.',chan);
            return
          end
          if ~isnumeric(val)
            warning('SGRLAB:FPAS','gain = %s which is not numeric.',val);
            return
          end
          
          %allowed values of gain are integers 0 to 7
          val = round(val);
          if val<VAL_MIN, val=VAL_MIN;end
          if val>VAL_MAX, val=VAL_MAX;end
          
          %allowed channels are 0 to 255. (note only nChan channels do
          %anything with the current hardware) Also the channel numbering
          %is 0 based in the hardware but 1 based in Matlab. So Matlab
          %channel 1 = hardware channel 0!
          chan = round(chan); %make it integer
          chan = chan - 1; %convert from 1 based to 0 based counting
          %enforce bounds 0 to 255
          if chan<CHAN_MIN,chan=CHAN_MIN;end
          if chan>CHAN_MAX,chan=CHAN_MAX;end
          
          %see FPAS2 Serial Communications Commands for specification.
          %Basically I is for command. G means set the gain. xxx is the channel
          %and yyy is the gain value (0-7)=> IGxxxyyy
          fprintf(obj.COMPort,sprintf('IG%03.0f%03.0f',chan,val));
          drawnow;
          pause(0.1);
        end
        
        function SetGainAllPixels(obj,gain)
          n = obj.nPixels;
          for i = 1:n
            obj.SetGain(n,gain);
          end
        end

        function SetGainAll(obj,gain)
          n = obj.nChan;
          for i = 1:n
            obj.SetGain(n,gain);
          end
        end

        function SetGainRange(obj,highlow)
          %input values of 0.5 or higher are high gain. Less than 0.5 low
          %gain.

          %make sure input is a number
          if ~isnumeric(highlow)
            warning('SGRLAB:FPAS','highlow = %s which is not numeric.',highlow);
            return
          end
          
          highlow = round(highlow); %make it integer
          highlow = (highlow>=1); %make >1 to 1, <1 to 0. 
          %see FPAS2 Serial Communications Commands for specification.
          %Basically I is for command. L means set the gain range. 00000 is
          %a filler. v is the value 0=low or 1=high. => IL00000v IGxxxyyy
          fprintf(obj.COMPort,sprintf('IL%06.0f',highlow));
          drawnow;
          pause(0.1);
          
        end
        
        function SetTrim(obj,chan,val)
          CHAN_MAX = 255;
          CHAN_MIN = 0;
          VAL_MAX = 255;
          VAL_MIN = 0;
          
          %make sure input is a number
          if ~isnumeric(chan)
            warning('SGRLAB:FPAS','chan = %s which is not numeric.',chan);
            return
          end
          if ~isnumeric(val)
            warning('SGRLAB:FPAS','gain = %s which is not numeric.',val);
            return
          end
          
          %allowed values of gain are integers 0 to 7
          val = round(val);
          if val<VAL_MIN, val=VAL_MIN;end
          if val>VAL_MAX, val=VAL_MAX;end
          
          %allowed channels are 0 to 255. (note only nChan channels do
          %anything with the current hardware) Also the channel numbering
          %is 0 based in the hardware but 1 based in Matlab. So Matlab
          %channel 1 = hardware channel 0!
          chan = round(chan); %make it integer
          chan = chan - 1; %convert from 1 based to 0 based counting
          %enforce bounds 0 to 255
          if chan<CHAN_MIN,chan=CHAN_MIN;end
          if chan>CHAN_MAX,chan=CHAN_MAX;end
          
          %see FPAS2 Serial Communications Commands for specification.
          %Basically I is for command. T means set the trim. xxx is the channel
          %and yyy is the gain value (0-255)=> IGxxxyyy
          fprintf(obj.COMPort,'IT%03.0f%03.0f',chan,val);
          drawnow;
          pause(0.1);
          
        end
        
        function SetTrimAllPixels(obj,val)
          n = obj.nPixels;
          for i = 1:n
            obj.SetTrim(n,val);
          end          
        end
        
        function SetTrimAll(obj,trim)
          n = obj.nChan;
          for i = 1:n
            obj.SetTrim(n,trim);
          end          
        end
        
        function IntegrationGate(obj,delay_ns,width_ns)
          %not yet tested
          warning('SGRLAB:UnderConstruction','WARNING! Changing the delay and gate have not been tested. You''d better hook up the channels from the back of the FPAS to a scope and make sure you know what you are doing!')
          DELAY_OFFSET = 50; %ns
          DELAY_UNITS = 5; %ns (convert ns to hardware units)
          WIDTH_OFFSET = 54; %ns
          WIDTH_UNITS = 20; %ns (convert ns to hardware units)
          delay  = (delay_ns(1) - DELAY_OFFSET)/DELAY_UNITS;
          width = (width_ns(1) - WIDTH_OFFSET)/WIDTH_UNITS;
  
          %see FPAS2 Serial Communications Commands for specification.
          %Basically I is for command. W means set the gate delay and
          %width. xxx is the delay and yyy is the width value (0-255)=> IWxxxyyy
          fprintf(obj.COMPort,'IW%03.0f%03.0f',delay,width);
          drawnow;
          pause(0.1);
          
        end
        %
        % CLEANUP TASKS GO HERE
        %
        function delete(obj)
          try
            ClearTask(obj);
          catch E
            disp(E);
            warning('SGRLAB:UnderConstruction','clear task failed. Probably already cleared')
          end
          
          CloseCOMPort(obj);
        end
    end
    
end
