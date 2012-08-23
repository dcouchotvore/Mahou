function [position,bin] = processPosition(data,bin_zero)
global fringeToFs
flag_debug = false;

%mimic the objects
nShots = size(data,2);
PARAMS.nShots = nShots;
obj.sample.data.external = data(65:80,:);
obj.sample.mean.external = mean(obj.sample.data.external,2);
obj.theta = 0; %zeros(1,nShots); %?®
obj.position = -500;%? initial position (fs)
obj.sample.position = zeros(1,nShots); %?


            % Determine relative position of each sample in nm
            % Assuming channel 15 is phase-x and 16 is phase-y
            obj.sample.position = zeros(PARAMS.nShots);
            obj.sample.data.external(15,:) = obj.sample.data.external(15,:) - obj.sample.mean.external(15);
            obj.sample.data.external(16,:) = obj.sample.data.external(16,:) - obj.sample.mean.external(16);

            %show some points if we are debugging
            if flag_debug
            figure(1),clf,
            plot(obj.sample.data.external(15,:),...
                obj.sample.data.external(16,:),'-o')
            hold on,
            plot(obj.sample.data.external(15,1),...
                obj.sample.data.external(16,1),'o',...
                'MarkerFaceColor',[0 0 1]);
            hold off
            ax = axis;
            l=line([0 1;0 -1],[-1 0;1 0]);
            set(l,'Color',[0.2 0.2 0.2])
            axis square
            axis(ax);
            drawnow
            end
            
            %this algorithm requires >4 points per cycle. It will fail if
            %points cross more than 2 axes at a time
            %try to vectorize
            x = obj.sample.data.external(15,2:end);
            y = obj.sample.data.external(16,2:end);
            last_x = obj.sample.data.external(15,1:end-1);
            %last_y = obj.sample.data.external(16,1:end-1); %SGR algorithm
            %doesn't use last_ys

            incr = zeros(1,nShots-1);
            %Here is my truth table idea. We count up if y>0 AND last_x<0
            %AND x>=0. Call these a b and c (a AND b AND c). We count down
            %if y>0 AND last_x>=0 AND x<0 (a AND ~b AND ~c). Use these
            %rules to make increment plus or minus 1. Note the use of >= to
            %define x=0 to be in the (+,+) quadrant of the x-y plane. This
            %makes the NOT conditions exclusive. Probably never will happen
            %but whatever.
            a = y>0;
            b = last_x<0;
            c = x>=0;
            incr(a & b & c) = 1;
            incr(a & ~b & ~c) = -1;
            position = [0 cumsum(incr)]*fringeToFs + obj.position;
            
%             incr = [0 zeros(1,nShots-1)];
%             x = obj.sample.data.external(15,2:end);
%             y = obj.sample.data.external(16,2:end);
%             last_x = obj.sample.data.external(15,1:end-1);
%             last_y = obj.sample.data.external(16,1:end-1);
%             incr = [0 zeros(1,nShots-1)];
%             
%             %this algorithm requires >4 points per cycle. It will fail if
%             %points cross more than 2 axes at a time
%             %probably can vectorize this
%             for ii = 1:nShots-1                
%                 if  y(ii)>0 
%                     %if we are in the upper plane
%                     if last_x(ii)<=0 && x(ii) >0
%                            %if we are moving right across the x-axis
%                         incr(ii+1) = 1;
%                     elseif last_x(ii)>=0 && x(ii)<0
%                         incr(ii+1) = -1;
%                     end
%                 end
%             end
%             
%             position = cumsum(incr)*fringeToFs + obj.position;
            bin = timeFsToBin(position,bin_zero);
            
            return
            
%             last_x = -1;
%             last_y =  1;
%             for ii = 1:PARAMS.nShots
%                 x = sign(obj.sample.data.external(15, ii)) %% ??? .data. missing?
%                 y = sign(obj.sample.data.external(16, ii))
% 
%                 % consider every axis
%                 if x>0 && last_x<0 && y>0
%                     t_theta = 0;
%                     dir  = +1;
%                 elseif x<0 && last_x>0 && y>0
%                     t_theta = 0;
%                     dir  = -1;
%                 elseif y<0 && last_y>0 && x>0
%                     t_theta = 1;
%                     dir  = +1;
%                 elseif y>0 && last_y<0 && x>0
%                     t_theta = 1;
%                     dir  = -1;
%                 elseif x<0 && last_x>0 && y<0
%                     t_theta = 2;
%                     dir  = +1;
%                 elseif x>0 && last_x<0 && y<0
%                     t_theta = 2;
%                     dir  = -1;
%                 elseif y>0 && last_y<0 && x<0
%                     t_theta = 3;
%                     dir  = +1;
%                 elseif y<0 && last_y>0 && x<0
%                     t_theta = 3;
%                     dir  = -1;
%                 else continue;
%                 end
%             end
% 
%             % Determine increment in position.  Allow that some axis
%             % crossings could be missed.
%             incr = dir * mod(t_theta-obj.theta, 4)/4.0 * 2.11; % @@@ ??? 632.816; %HeNe wavelength in air
%             obj.theta = t_theta;
%             obj.position = obj.position + incr; 
%             obj.sample.position(ii) = obj.position;
% 
%             % Fill in samples that were missed.  %@@@ ??? probably a more
%             % efficient way to do this.
%             indices = find(obj.sample.position);
%             for ii=1:PARAMS.nShots
%                 if obj.sample.position==0
%                     lower = last(find(indices>=ii));        %%@@@ ??? May have trouble with leading/trailing zeros
%                     upper = first(find(indices<=ii));
%                     val = (obj.position(lower)*(upper-ii)+obj.position(upper)*(ii-lower))/(upper-lower);
%                     if val>0
%                         obj.sample.position = val;
%                     end
%                 end
%             end
position = obj.sample.position;