classdef Method_Basic2DScan < handle
    
    properties
        hPlot;
        plot_data;
        mean_data;
    end
     
    methods
        
        function obj = Method_2DScan
            obj.plot_data = zeros(32, 32);
            obj.mean_data = zeros(32, 32);
        end

        function InitializePlot(obj, handles)
            obj.hPlot = contourf(obj.plot_data, 16);
            set(obj.hPlot,'DataSource', 'method.PlotData(1)');
            colormap(handles.axesMain, 'Jet');
        end

        function value = PlotData(obj, N)
            switch N
                case 1
                    value = obj.plot_data;
                otherwise
                    error('Unknown plot data index');
            end
        end

        function InitializeData(obj, ~)
            obj.plot_data = zeros(32, 32);
            obj.mean_data = zeros(32, 32);
        end

        function Scan(obj, handles)
            global PARAMS Interferometer_Stage;
            Interferometer_Stage.MoveTo(handles, PARAMS.start, 100, 0, 0);
            speed_nmpp = 78.75;                 % nm/pulse
            speed_stage = speed_nmpp*5000;      % nm/second
            PARAMS.nShots = (PARAMS.stop-PARAMS.start)/speed_nmpp;
            Interferometer_Stage.MoveTo(handles, PARAMS.stop, speed_stage, 0, 1);
            
            % Get the data.  FPAS_Sample gates the clock.
            
            sample = FPAS_Sample;
            
            % Standard signal processing
            obj.plot_data = Log10(sample.mean(33:64)./sample.mean(1:32));
            
            % Determine relative position of each sample in nm
            % Assuming channel 15 is phase-x and 16 is phase-y
            sample.position = zeros(PARAMS.nShots);
            last_pos = 0.0;
            relative_pos = 0.0;
            fill_ptr = 1;
            prior_x_negative = sample.data.external(15, 1)<0;
            sample.data.external(15,:) = sample.data.external(15,:)./sample.mean.external(15);
            sample.data.external(16,:) = sample.data.external(16,:)./sample.mean.external(16);
            for ii = 2:PARAMS.nShots
                if sample.external(16, ii)>=0 && prior_x_negative;
                    if sample.external(15, ii)>=0
                        relative_pos = relative_pos + 632.816; %HeNe wavelength in air
                    else
                        relative_pos = relative_pos + 632.816; %HeNe wavelength in air
                    end
                    n_samples = ii-fill_ptr;
                    if n_samples>1
                        incr = (relative_pos-last_pos)/n_samples;
                        for jj = 1:n_samples;
                            sample.position(fill_ptr+jj) = last_pos+incr*jj;
                        end
                    end
                end
            end
            
            
            refreshdata(obj.hPlot, 'caller');
            RefreshRawData(handles, sample);
            drawnow;

            obj.plot_data = fft(obj.plot_data);
            refreshdata(obj.hPlot, 'caller');
            drawnow;
            Interferometer_Stage.MoveTo(handles, PARAMS.start, 50, 0, 1);
            pause(1.0);
            obj.mean_data = ((obj.mean_data*ii)+obj.plot_data)/(ii+1);
  
            obj.plot_data = obj.mean_data;
            refreshdata(obj.hPlot, 'caller');
            drawnow;
        end
        
        function Save(obj, filename)
            save(filename, obj.plot_data);
        end

    end
end


            