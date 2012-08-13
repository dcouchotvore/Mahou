function t_profile = rampProfile(options)
%calculate a ramp profile to simulate the motion of the motor forward and
%back for a complete scan of a 2D spectrum
%
% t_profile = rampProfile(options)
%
% input options structure as follows:
%
% options.t_start (ps)
% options.t_end (ps)
% options.fringes_per_shot (how many hene fringes to move per laser shot,
%      roughly 0.25 for slow scanning)
% options.laser_rep_rate (Hz)
% options.acceleration (mm/s^2) (dictated by max hardware accel.)

global fringeToFs c_SI 

flag_plot = 0;

% t_start = -0.500;
% t_end = 1;
% laser_rep_rate = 5000; %hz
% fringes_per_shot = 0.25;
% accel = 10; %mm / s^2

%time internally is in ps, but externally is in fs
t_start = options.t_start/1000;
t_end = options.t_end/1000;
t_offset = options.timing_error/1000;
laser_rep_rate = options.laser_rep_rate;
fringes_per_shot = options.fringes_per_shot;
accel = options.acceleration;

% 
% don't change below here
%
%target velocity
%slow scanning should be something like 2.11/4 = 0.5 fs per laser shot
vel_ps_per_s = fringes_per_shot * fringeToFs/1000 * laser_rep_rate;

%convert ps to mm using c (in m/s) and double pass geometry convert m to mm
%(*1000) amd 1/s to 1/ps (*1e-12)
psToMm = c_SI*1000/2*1e-12;
mmToPs = 1/psToMm;

%convert to mm
vel_mm_per_s = vel_ps_per_s * psToMm;


%hw delay (mimic time between starting DAC and starting motor)
delay_s = 0.05; %

max_steps = 1e6;

dlabt = 1/laser_rep_rate; %how often we sample in lab time (s)
delay_steps = round(delay_s/dlabt);

%how long does it take to ramp up or down to target velocity
ramp_time = vel_mm_per_s / accel;
ramp_dist = 0.5*accel*ramp_time^2;

x_target = (t_end-t_start)*psToMm;

%position noise roughly 632.8 nm /100
noise = 0.0006/100;

%initialize for the loop
x = zeros(1,max_steps);
v = zeros(1,max_steps);
a = accel;
target_reached = false;
%delay on start
for i = 2:delay_steps
  x(i) = x(i-1) + noise*randn;
end
count = delay_steps;

%forward
for i = count+1:max_steps
  if target_reached, break, end
  count = count+1;

  %could be smarter about this but for now keep it easy
  x(i) = x(i-1) + v(i-1)*dlabt + 0.5*a*dlabt^2 + noise*randn;
  v(i) = v(i-1) + a*dlabt;
  if v(i) > vel_mm_per_s
    a = 0;
  end
  if x(i) >= x_target- 0.9*ramp_dist
    a = -accel;
  end
  if round(x(i)*1000)/1000 >= x_target
    target_reached = true;
  end
end
%delay on stop
for i = count+1:count+delay_steps
  x(i) = x(i-1) + noise*randn;
end
count = count+delay_steps;

if flag_plot
  figure(7),clf,
  subplot(3,1,1)
  %plot(x_profile,'-o')
  plot(x(1:count),'-o')
  subplot(3,1,2)
  %plot(v_profile,'-o')
  plot(v(1:count),'-o')
end

%delay on restart
for i = count+1:count+delay_steps
  x(i) = x(i-1) + noise*randn;
end
count = count+delay_steps;

%backward
a = -accel; 
target_reached = false;
for i = count:max_steps
  
  if target_reached, break, end
  count = count+1;

  %could be smarter about this but for now keep it easy
  x(i) = x(i-1) + v(i-1)*dlabt + 0.5*a*dlabt^2 + noise*randn;
  v(i) = v(i-1) + a*dlabt;
  if v(i) <= -vel_mm_per_s
    a = 0;
  end
  if x(i) <= 0 + 0.9 * ramp_dist
    a = accel;
  end
  if round(x(i)*1000)/1000 <= 0
    target_reached = true;
  end
end
%delay on restop
for i = count:count+delay_steps
  x(i) = x(i-1) + noise*randn;
end
count = count+delay_steps;

if flag_plot
  figure(8),clf,
  subplot(3,1,1)
  %plot(x_profile,'-o')
  plot(x,'-o')
  subplot(3,1,2)
  %plot(v_profile,'-o')
  plot(v,'-o')
end

x_profile = x(1:count);
%v_profile = v(1:count);
t_profile = x_profile*mmToPs + t_start - t_offset;

if flag_plot
  figure(9),clf
  plot(t_profile);
end

