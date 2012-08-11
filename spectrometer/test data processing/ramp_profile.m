function t_profile = ramp_profile(options)
%calculate a ramp profile to simulate the motion of the motor
% t_profile = rampProfile(options)
%
% input options structure as follows:
% options.t_start
% options.t_end
% options.laser_rep_rate
% options.fringes_per_shot (how many hene fringes to move per laser shot,
% roughly 0.25 for slow scanning)
%

global fringeToFs c_SI 

flag_plot = 0;

% simulate time axis
t_start = -0.500;
t_end = 1;

%slow scanning should be something like 2.11/4 = 0.5 fs per laser shot
laser_rep_rate = 5000; %hz

%target velocity
vel_ps_per_s = fringes_per_shot * fringeToFs/10000.0005 * laser_rep_rate;

% 
% don't change below here
%

%convert ps to mm using c (in m/s) and double pass geometry convert m to mm
%(*1000) amd 1/s to 1/ps (*1e-12)
psToMm = c_SI*1000/2*1e-12;
mmToPs = 1/psToMm;

%convert to mm
vel_mm_per_s = vel_ps_per_s * psToMm;

%accel (dictated by hardware -- 0.1 should be close but probably too low)
accel = 10; %mm / s^2

%hw delay (mimic time between starting DAC and starting motor)
delay_s = 0.05; %

max_steps = 2e4;

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
  if x(i) >= x_target-ramp_dist
    a = -accel;
  end
  if x(i) >= x_target
    target_reached = true
  end
end
%delay on stop
for i = count+1:count+delay_steps
  x(i) = x(i-1) + noise*randn;
end
count = count+delay_steps;

%delay on restart
for i = count+1:count+delay_steps
  x(i) = x(i-1) + noise*randn;
end
count = count+delay_steps;

if flag_plot
  figure(7),clf,
  subplot(3,1,1)
  plot(x_profile,'-o')
  %plot(x,'-o')
  subplot(3,1,2)
  plot(v_profile,'-o')
  %plot(v,'-o')
end

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
  if x(i) <= 0+ramp_dist
    a = accel;
  end
  if x(i) <= 0
    target_reached = true
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
t_profile = x_profile*mmToPs + t_start;

if flag_plot
  figure(9),clf
  plot(t_profile);
end

