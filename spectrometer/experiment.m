    function [position,bin] = processPosition(data,options)
        global fringeToFs
        flag_debug = false;

        %mimic the objects
        nShots = size(data,2);
        obj.nShots = nShots;
        obj.sample.data.external = data(65:80,:);
        obj.sample.mean.external = mean(obj.sample.data.external,2);
        obj.theta = 0; %zeros(1,nShots); %?®
        obj.position = -500;%? initial position (fs)
        obj.sample.position = zeros(1,nShots); %?

        % Determine relative position of each sample in nm
        % Assuming channel 15 is phase-x and 16 is phase-y
        obj.sample.position = zeros(obj.PARAMS.nShots);
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

        bin = timeFsToBin(position,options);
        position = obj.sample.position;

        return
    end