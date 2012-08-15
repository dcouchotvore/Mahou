<<<<<<< HEAD
classdef Sampler_FPAS < handle
    
    properties (SetAccess = private)
        sample;
        nPixels;
        nExtInputs;
        nMaxChan;
        nSampsPerChan;
        lib;
        initialized
        sample;
    end

    methods
        
        function obj = Sampler_FPAS
            LoadNIConstants;
        end
        
        function Intialize(obj)
            
            %propteries of the array detector
            obj.nPixels = 64;
            obj.nExtInputs = 16;
            obj.nMaxChan = 256; %the number of channels written to the FIFO buffer in the FPAS
            obj.nSampsPerChan = FPAS.nMaxChan/2*PARAMS.nShots+1; %nChan/2+1; %total number of points to acquire #Ch*#scans (where scans is NI language for shots)

            %% load library
            obj.lib = 'myni';	% library alias
            if ~libisloaded(obj.lib)
                disp('Matlab: Load nicaiu.dll')
                loadlibrary('nicaiu.dll','C:\Program Files (x86)\National Instruments\NI-DAQ\DAQmx ANSI C Dev\include\nidaqmx.h','alias',FPAS.lib);
                %if you do NOT have nicaiu.dll and nidaqmx.h
                %in your Matlab path,add full pathnames or copy the files.
                %libfunctions(FPAS.lib,'-full') % use this to show the... 
                %libfunctionsview(FPAS.lib)     % included function
            end
            disp('Matlab: dll loaded')

            % %% load all DAQmx constants
            % if ~exist('flag_NIconstants_defined','var') || ~flag_NIconstants_defined
            %     NIconstants;    
            % end
            disp('done')

            %% reset device
            %devName = 'Dev1'; %as defined in NI MAX program
            obj.initialized = 0;
            try 
                DAQmxResetDevice(FPAS.lib,'Dev1');
                obj.initialized = 1;
            catch
                warning('Spectrometer:FPAS', 'FPAS system not found.  Entering simulation mode.');
            end
        end
        
        function Start(obj)
            global NICONST;
            if obj.initialized
                obj.nSampsPerChan = obj.nMaxChan/2*PARAMS.nShots+1; %nChan/2+1; %total number of points to acquire #Ch*#scans (where scans is NI language for shots)
                [obj.hTask,obj.nChan] = DAQmxCreateDIChan(obj.lib,{'Dev1/line0:31'},NICONST.DAQmx_Val_ChanForAllLines,'',{''});
                %here numchan is the number of digital input channels, i.e. just 1

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
                bufSizeInSamps = sampsPerChan*numchan;
                DAQmxCfgInputBuffer(lib,hTask,bufSizeInSamps);

                %% set DMA transfer
                DAQmxSetDIDataXferMech(lib,hTask,chanName,DAQmx_Val_DMA);

                %% commit (make everything as ready to go as it can be)
                DAQmxTaskControl(lib,hTask,DAQmx_Val_Task_Commit);
                
                %% start the task
                DAQmxStartTask(obj.lib, obj.hTask);
            end
        end

        % Finish up and collect data
        function result = Finish(obj)
            global NICONST IO PARAMS;
            
            if obj.initialized

                %% read 
                timeout = 1;
                fillMode = NICONST.DAQmx_Val_GroupByChannel; % Group by Channel
                %fillMode = DAQmx_Val_GroupByScanNumber; % I think this doesn't matter when only 1 channel

                IO.OpenClockGate;
                [portdata,sampsPerChanRead] = DAQmxReadDigitalU32(FPAS.lib,FPAS.hTask,FPAS.nChan,FPAS.nSampsPerChan,timeout,fillMode,FPAS.nSampsPerChan*FPAS.nChan);
                IO.CloseClockGate;

                %portdata

                %% stop
                DAQmxStopTask(FPAS.lib,FPAS.hTask);

                %% clear
                DAQmxClearTask(FPAS.lib,obj.hTask);

                %% swizzle data (could be optimized for memory and speed)
                nPerBoard = 32; %has to do with the number of channels on the boards going to the FIFO

                ind = [];
                for ii = 1:ceil((obj.nPixels+obj.nExtInputs)/nPerBoard)
                  ind = [ind,[1:2:15 2:2:16; 17:2:31 18:2:32]+(ii-1)*32];
                end
                ind = ind(:);

                %how many channels do you need to keep to unravel all the data correctly
                maxInd = ceil((obj.nPixels+obj.nExtInputs)/nPerBoard)*nPerBoard; 

                %throw away first point because it is empty
                hm = portdata(2:end);

                %throw away as many points as we can without losing information
                hm = reshape(hm,obj.nMaxChan/2,PARAMS.nShots);
                hm = hm(1:maxInd/2,:);

                %flatten again
                hm = hm(:); 

                %convert each 32bit number to two 16bit numbers
                hmm = typecast(hm,'uint16');
                hmm = reshape(hmm,maxInd,PARAMS.nShots);

                %use ind to sort the data
                IND = repmat(ind,1,PARAMS.nShots); %this only needs to happen once per scan
                data = zeros(size(IND)); %initialize size of array (once per scan)
                data = hmm(ind,1:PARAMS.nShots);

                %% extract array part and ext channels part
                obj.sample.data.pixels = double(data(1:obj.nPixels,:)); %the first 64 rows
                obj.sample.data.external = double(data((obj.nPixels+1):(obj.nPixels+FPAS.nExtInputs),:))./13107; %the last 16 rows divided by some magic number I don't understand to make volts?

            % If in simulation mode, duplicate method 2
            else
                for ii=1:32
                    obj.sample.data.pixels(ii, :)   = abs(sech((ii-14)/6)^2 + random('Normal', 0, .2, 1, PARAMS.nShots));
                    obj.sample.data.pixels(ii+32,:) = abs(sech((ii-18)/6)^2 + random('Normal', 0, .2, 1, PARAMS.nShots));
                end
                obj.sample.data.external = random('uniform', 0.0, 5.0, 16, PARAMS.nShots);
            end
            
            obj.sample.mean.pixels = mean(obj.sample.data.pixels, 2);
            obj.sample.mean.external = mean(obj.sample.data.external, 2);

            obj.sample.mOD = log10(obj.sample.data.pixels([33:64],:)./obj.sample.data.pixels([1:32],:))*1000;
            obj.sample.noise = std(obj.sample.mOD, 1, 2);
            obj.sample.mOD = mean(obj.sample.mOD, 2);           % @@@ ??? Fix for FPAS
            obj.sample.abs_noise = (std(obj.sample.data.pixels(16,:))+std(obj.sample.data.pixels(17,:)))/2;
            
            result = obj.sample;
        end

    end
end
=======
classdef Sampler_FPAS < handle
    
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
    
    methods
        
        function obj = Sampler_FPAS
            LoadNIConstants;
        end
        
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

            %% reset device
            obj.initialized = 0;
            try 
                DAQmxResetDevice(obj.lib,obj.deviceName);
                obj.initialized = 1;
            catch
                warning('Spectrometer:FPAS', 'FPAS system not found.  Entering simulation mode.');
            end
        end
        
        function ConfigureTask(obj,PARAMS)
          global NICONST
          if obj.initialized
            obj.nShots = PARAMS.nShots;
            obj.nSampsPerChan = obj.nMaxChan/2*obj.nShots+1; %nChan/2+1; %total number of points to acquire #Ch*#scans (where scans is NI language for shots)
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
                  warning('maybe did not get all the data??? debug nSampsPerChan and sampsPerChanRead.');
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

            end
        end
        
        function ClearTask(obj)
          %% clear
          DAQmxClearTask(obj.lib,obj.hTask);
          
        end

        
    end
    
end
>>>>>>> 83f2685ce7e00e27078dce075bb99b1d82777eaa
