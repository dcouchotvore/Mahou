%for an exponential c2(t)
dt = .04; %ps
n_t = 32;
flag_print = 0
n_interp = 16;
order = 5;
%damping = 'overdamped'; %critical or overdamped
%damping = 'critical';
%damping = 'multiexp';
damping = 'hynesform';

Delta_cm = 90; %linewidth (sigma) in wavenumbers
tau = .15; % correlation time in ps
%tau = 10 %v. large
%tau = .02; %smallest w/o NaN probs
%weird side bands when tau=10...?

%population times
t2_array = [.0 0.04 0.08 0.44];
t4_array = [.0 0.04 0.08 0.44];
n_t2_array = length(t2_array);
c = 2.9979e10;
wavenumbersToInvPs=c*1e-12;
invPsToWavenumbers=1/wavenumbersToInvPs;
t=0:dt:(n_t-1)*dt;
a=1/dt*invPsToWavenumbers;
%w = (-a/2:a/(n_t-1):a/2);
dw = a/(n_t-1);
w=(-a/2:dw:a/2)-dw/2;


Delta = Delta_cm*wavenumbersToInvPs*2*pi;%apparently this is in
                                         %radians/s not just Hz...
Lambda = 1/tau;

disp(['Delta / Lambda = ',num2str(Delta/Lambda)]);
disp(['Delta = ',num2str(Delta),' ps^-1']);
disp(['Lambda = ',num2str(Lambda),' ps^-1']);

switch damping,
  case 'overdamped'
    %overdamped exp(-t/tau)
    g = @(t) Delta^2/Lambda^2.*(exp(-Lambda.*t)-1+Lambda.*t);
  case 'critical'
    %critically damped (1+2t/tau)exp(-2t/tau)
    g = @(t) Delta^2/4/Lambda^2.*exp(-2.*Lambda.*t) ...
      .*(3 + 2*Lambda*t + exp(2.*Lambda.*t).*(4*Lambda.*t - 3));
  case 'multiexp'
    %multiexponential
    Delta1_cm  = sqrt(0.72*Delta_cm^2);
    Delta2_cm = sqrt(0.28.*Delta_cm^2);
    tau1 = .1;
    tau2 = 1;
    
    Delta1 = Delta1_cm*wavenumbersToInvPs*2*pi;
    Delta2 = Delta2_cm*wavenumbersToInvPs*2*pi;
    Lambda1 = 1/tau1;
    Lambda2 = 1/tau2;
    g = @(t) Delta1^2/4/Lambda1^2.*exp(-2.*Lambda1.*t) ...
      .*(3 + 2*Lambda1*t + exp(2.*Lambda1.*t).*(4*Lambda1.*t - 3)) ...
      + Delta2^2/4/Lambda2^2.*exp(-2.*Lambda2.*t) ...
      .*(3 + 2*Lambda2*t + exp(2.*Lambda2.*t).*(4*Lambda2.*t - 3));
 case 'hynesform'
  %fit c2 to hynes type function, double integrate with Mathematica
  %to find g(t)
  a1 = 0.3232;
  k11 = 30.01; %ps-1
  k12 = 17.41; %ps-1
  a2 = 0.3378;
  k2 = 8.270; %ps-1
  a3 = 0.3455;
  k3 = 1.897; %ps-1
  
  %yuck
  g = @(t) Delta^2*exp(-t.*(k12+k2+k3))/(k2^2*k3^2*(k11^2+k12^2)^2) ...
      .*(a1*k2^2*k3^2.*exp((k2+k3).*t).*(cos(k11.*t).*(k12^2-k11^2)-2*k11*k12*sin(k11*t) ...
					 + exp(k12.*t).*(k11^2*(k12.*t+1)+k12^2*(k12.*t-1))) ... 
	 + (k11^2+k12^2)^2.*exp(k12.*t).*(a3*k2^2*exp(k2.*t).*(exp(k3.*t).*(k3.*t-1)+1) ...
					  +a2*k3^2*exp(k3.*t).*(exp(k2.*t).*(k2*t-1)+1)));
  otherwise
    error('damping value is unknown');
end

if order>=1
  if n_interp == 1
    S = fftshift(real(fft(exp(-g(t)))));
  else
    S = fftshift(real(petersfft(exp(-g(t)),n_interp)));
  end
end

if order>=3
  [T1,T3] = meshgrid(t,t);
  for i=1:n_t2_array
    t2 = t2_array(i);
  if n_interp==1
    P1=fft2(exp(-g(T1)+g(t2)-g(T3)-g(T1+t2)-g(t2+T3)+g(T1+t2+T3)));
    P2=fft2(exp(-g(T1)-g(t2)-g(T3)+g(T1+t2)+g(t2+t3)-g(T1+t2+T3)));
  else
    P1=petersfft2(exp(-g(T1)+g(t2)-g(T3)-g(T1+t2)-g(t2+T3)+g(T1+t2+T3)),n_interp);
    P2=petersfft2(exp(-g(T1)-g(t2)-g(T3)+g(T1+t2)+g(t2+T3)-g(T1+t2+T3)),n_interp);
  end
  P{i}=fftshift(real(fliplr(circshift(P1,[0 -1]))+P2));
  end
end

if order>=5
  for i = 1:n_t2_array
  [T1,T3,T5] = meshgrid(t,t,t);
  t2 = t2_array(i);
  t4 = t4_array(i);
  if n_interp==1
%    R1 = fftn(exp(-g(T1+T3+T5)));
%    R2 = fftn(exp(-2.*g(T1)-2.*g(T3+T5)+g(T1+T3+T5))); %flip w1
%    R3 = fftn(exp(-2.*g(T1)-4.*g(T3)-2.*g(T5)+2.*g(T1+T3)+2.*g(T3+T5)-g(T1+T3+T5))); %flip  w3
%    R4 = fftn(exp(-2.*g(T5)-2.*g(T1+T3)+g(T1+T3+T5))); %flip w1 and w3
    R1 = fftn(exp(-g(T1)-g(t2)-g(T3)-g(t4)-g(T5) ...
      +g(T1+t2)+g(t2+T3)+g(T3+t4)+g(t4+T5) ...
      -g(T1+t2+T3)-g(t2+T3+t4)-g(T3+t4+T5) ...
      +g(T1+t2+T3+t4)+g(t2+T3+t4+T5) ...
      -g(T1+t2+T3+t4+T5)));
    R2 = fftn(exp(-g(T1)+g(t2)-g(T3)-g(t4)-g(T5) ...
      -g(T1+t2)-g(t2+T3)+g(T3+t4)+g(t4+T5) ...
      +g(T1+t2+T3)+g(t2+T3+t4)-g(T3+t4+T5) ...
      -g(T1+t2+T3+t4)-g(t2+T3+t4+T5) ...
      +g(T1+t2+T3+t4+T5)));
    R3 = fftn(exp(-g(T1)+g(t2)-g(T3)+g(t4)-g(T5) ...
      -g(T1+t2)-g(t2+T3)-g(T3+t4)-g(t4+T5) ...
      +g(T1+t2+T3)-g(t2+T3+t4)+g(T3+t4+T5) ...
      +g(T1+t2+T3+t4)+g(t2+T3+t4+T5) ...
      -g(T1+t2+T3+t4+T5)));
    R4 = fftn(exp(-g(T1)-g(t2)-g(T3)+g(t4)-g(T5) ...
      +g(T1+t2)+g(t2+T3)-g(T3+t4)-g(t4+T5) ...
      -g(T1+t2+T3)+g(t2+T3+t4)+g(T3+t4+T5) ...
      -g(T1+t2+T3+t4)-g(t2+T3+t4+T5) ...
      +g(T1+t2+T3+t4+T5)));
  else
    R1 = petersfft3(exp(-g(T1)-g(t2)-g(T3)-g(t4)-g(T5) ...
      +g(T1+t2)+g(t2+T3)+g(T3+t4)+g(t4+T5) ...
      -g(T1+t2+T3)-g(t2+T3+t4)-g(T3+t4+T5) ...
      +g(T1+t2+T3+t4)+g(t2+T3+t4+T5) ...
      -g(T1+t2+T3+t4+T5)),n_interp);
    R2 = petersfft3(exp(-g(T1)+g(t2)-g(T3)-g(t4)-g(T5) ...
      -g(T1+t2)-g(t2+T3)+g(T3+t4)+g(t4+T5) ...
      +g(T1+t2+T3)+g(t2+T3+t4)-g(T3+t4+T5) ...
      -g(T1+t2+T3+t4)-g(t2+T3+t4+T5) ...
      +g(T1+t2+T3+t4+T5)),n_interp);
    R3 = petersfft3(exp(-g(T1)+g(t2)-g(T3)+g(t4)-g(T5) ...
      -g(T1+t2)-g(t2+T3)-g(T3+t4)-g(t4+T5) ...
      +g(T1+t2+T3)-g(t2+T3+t4)+g(T3+t4+T5) ...
      +g(T1+t2+T3+t4)+g(t2+T3+t4+T5) ...
      -g(T1+t2+T3+t4+T5)),n_interp);
    R4 = petersfft3(exp(-g(T1)-g(t2)-g(T3)+g(t4)-g(T5) ...
      +g(T1+t2)+g(t2+T3)-g(T3+t4)-g(t4+T5) ...
      -g(T1+t2+T3)+g(t2+T3+t4)+g(T3+t4+T5) ...
      -g(T1+t2+T3+t4)-g(t2+T3+t4+T5) ...
      +g(T1+t2+T3+t4+T5)),n_interp);
 %    R1 = petersfft3(exp(-g(T1+T3+T5)),n_interp);
 %   R2 = petersfft3(exp(-2.*g(T1)-2.*g(T3+T5)+g(T1+T3+T5)),n_interp); %flip w1
 %   R3 = petersfft3(exp(-2.*g(T1)-4.*g(T3)-2.*g(T5)+2.*g(T1+T3)+2.*g(T3+T5)-g(T1+T3+T5)),n_interp); %flip  w3
 %   R4 = petersfft3(exp(-2.*g(T5)-2.*g(T1+T3)+g(T1+T3+T5)),n_interp); %flip w1 and w3
%    R1 = petersfft3(exp(-G135),n_interp);
%    R2 = petersfft3(exp(-2*G1-2*G35+G135),n_interp); %flip w1
%    R3 = petersfft3(exp(-2*G1-4*G3-2*G5+2*G13+2*G35-G135),n_interp); %flip  w3
%    R4 = petersfft3(exp(-2*G5-2*G13+G135),n_interp); %flip w1 and w3
  end
  %do the flips
  R2 = flipdim(circshift(R2,[0 -1 0]),2);
  R3 = flipdim(circshift(R3,[-1 0 0]),1);
  R4 = flipdim(flipdim(circshift(R4,[-1 -1 0]),1),2);
  R{i}  = fftshift(real(R1+R2+R3+R4));
  end
end

% trim stupid first frequency point...
w = w(2:end);
if order>=1,S = S(2:end);end
if order>=3,for i = 1:n_t2_array,P{i}=P{i}(2:end,2:end);end,end
if order>=5,for i = 1:n_t2_array,R{i}=R{i}(2:end,2:end,2:end);end,end
disp('done')

%%
return
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

figure(3),clf
my2dPlot(w,w,fftshift(real(P1(2:end,2:end))),10)
figure(4),clf
my2dPlot(w,w,fftshift(real(P2(2:end,2:end))),10)

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

figure(5),
for i = 1:n_t2_array,
  clf
  my2dPlot(w,w,P{i},10);
  if n_t2_array>1,pause,end
end

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

[dummy,ind1] = min((w+100).^2);
[dummy,ind2] = min((w-100).^2);
ind = 1:4;
figure(11),clf
my3dSlices(w,R,t2_array,t4_array,ind,ind1,ind2)

figure(12),clf
my3dProjections(w,R,1)
