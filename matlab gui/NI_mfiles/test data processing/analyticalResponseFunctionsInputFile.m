%This is an example of how to use analyticalResponseFunctions.m
%Here are the things you need to define:
flag_print = 0;
order = 3;

%system properties
%Delta_cm = 10; %linewidth (sigma) in wavenumbers
%tau = 2.; % correlation time in ps
%water:
Delta_cm  = 90;
tau = 0.5;
%tau = 10 %v. large
%tau = .02; %smallest w/o NaN probs
%weird side bands when tau=10...?
damping = 'overdamped'; %critical or overdamped
%damping = 'critical';
%damping = 'multiexp';
%damping = 'hynesform';

%population times to calculate
%t2_array = [.0 0.04 0.08 0.44];
%t4_array = [.0 0.04 0.08 0.44];
%t2_array = 0.3;
t2_array = 0.1; %for water
% t2_array = 0.2; %roughly like expts so far
%t2_array = 10;
t4_array = t2_array;
n_t2_array = length(t2_array);

%for an exponential c2(t)
%dt = 2*0.0021108; %ps
dt = 0.004;
n_t = 256; %number of time steps
w_0_cm = 1600; %center frequency
range = [-1200 1000];
labels = [-400:200:400];
%range = [-200 200];
%labels = [-150:150:150];
anh = 162;
two_level_system = false;
%two_level_system = true;

%details of fft
%fft_type = 'fft';
%fft_type = 'petersfft';
fft_type = 'sgrsfft';
n_interp = 1; %number of points of linear interpolation to use
n_zp = 1*n_t; %total length after zeropadding 
            %(make n_zp=n_t for no zero padding)
n_under = 0;

apodization = 'none';
%apodization = 'triangular';
%apodization = 'gaussian';

%type of projection to calculate
%projection_type = 'window';
projection_type = 'all';

% play with phase shifts
phi = 0; %phase shift in deg
noise = 0.0;

% simulate laser bandwidth
simulate_bandwidth = false;
%simulate_bandwidth = true;
bandwidth = 180; %cm-1 fwhm
bandwidth_axes = 2; %2 for scaled by LO spectrum, 3 for without

%
% Body of the calculation
%
analyticalResponseFunctions

%
% Print figures as needed
%
%%
figure(3),clf
my2dPlot(w,w,fftshift(real(P1(2:end,2:end))),'n_contours',20,'pumpprobe',false)
figure(4),clf
my2dPlot(w,w,fftshift(real(P2(2:end,2:end))),'n_contours',20,'pumpprobe',false)
figure(5),clf
ind = find(w>range(1)&w<range(2));
if isempty(ind), 
  ind = 1:length(P{1});
end
for i = 1:n_t2_array,
  clf
  my2dPlot(w(ind),w(ind),P{i}(ind,ind),'n_contours',20,'pumpprobe',false);
  if n_t2_array>1,pause,end
end

%% pump probe
figure(21),clf
my2dPlot(w,w,fftshift(real(PP(2:end,2:end))),'n_contours',20,'pumpprobe',false)


%%

return

%%
figure(10)
ind = find(w>=range(1)&w<=range(2));
for i = 1:n_t2_array,
  clf
  my3dPlot(w(ind),w(ind),w(ind),R{i}(ind,ind,ind),'labels',labels)
  if n_t2_array>1,pause,end
end

%%

figure(1)
subplot(1,2,1)
plot(t,g(t))
title('lineshape function g')
xlabel('t / ps')
%set(gca,'Xlim',[0 5*tau]);
subplot(1,2,2)
plot(t,exp(-g(t)))
xlabel('t / ps')
title('exp(-g)')
%set(gca,'Xlim',[0 5*tau]);


figure(6),clf
%offset_3d= R1(1,1,1);
%R1=R1-offset_3d;
my3dPlot(w,real(fftshift(R1(2:end,2:end,2:end))))

figure(7),clf
%offset_3d = R2(1,1,1);
%R2=R2-offset_3d;
my3dPlot(w,real(fftshift(R2(2:end,2:end,2:end))))

figure(8),clf
%offset_3d = R3(1,1,1);
%R3=R3-offset_3d;
my3dPlot(w,real(fftshift(R3(2:end,2:end,2:end))))

figure(9),clf
%offset_3d = R4(1,1,1);
%R4=R4-offset_3d;
my3dPlot(w,real(fftshift(R4(2:end,2:end,2:end))))


%%
figure(2),clf
norm_1d = trapz(S)*dw;
mean_1d = trapz(w.*S)*dw./norm_1d;
[max_1d,i] = max(S);
peak_1d = w(i)
plot(w,S,'-o',[peak_1d peak_1d],[0 max_1d*1.2],'k')
title('1d spec')
xlabel('\omega')
set(gca,'XLim',[-300 300]);

%%
figure(10)
for i = 1:n_t2_array,
  clf
  my3dPlot(w,R{i})
  if n_t2_array>1,pause,end
end

%%
[dummy,ind1] = min((w+100).^2);
[dummy,ind2] = min((w-100).^2);
ind = 1:4;
figure(11),clf
my3dSlices(w,R,t2_array,t4_array,ind,ind1,ind2)

figure(12),clf
my3dProjections(w,R,1)

%%
pump_probe(ind) = pump_probe(ind)./max(pump_probe(ind));
for i = 1:n_t2_array,
  switch projection_type
    case 'window'
      projection{i} = sum(P{i}(ind,ind),2);
    case 'all'
      projection{i} = sum(P{i},2);
      projection{i} = projection{i}(ind);
  end
  projection{i} = projection{i}./max(projection{i});
end
figure(6),
plot(w(ind),pump_probe(ind),'o',w(ind),projection{1})


