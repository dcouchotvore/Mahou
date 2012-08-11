% analyticalResponseFunctions.m Simulate response functions using the
% cumulant expansion. Input files should be setup using the template
% analyticalResponseFunctionInputFile.m
%
% There is a bug right now with undersampling and fftshifting the frequency
% axes, so I don't know what to do at the moment. Watch out! Probably best
% just to manually shift the freq axis. Maybe I can change things to use
% the data_analysis functions, which would be a good idea, I guess anyway.

% %Here are the things you need to define:
% flag_print = 0;
% order = 5;
% 
% %system properties
% %Delta_cm = 10; %linewidth (sigma) in wavenumbers
% %tau = 2.; % correlation time in ps
% %water:
% Delta_cm  = 90;
% tau = 0.15;
% %tau = 10 %v. large
% %tau = .02; %smallest w/o NaN probs
% %weird side bands when tau=10...?
% %damping = 'overdamped'; %critical or overdamped
% %damping = 'critical';
% %damping = 'multiexp';
% damping = 'hynesform';
% 
% %population times to calculate
% %t2_array = [.0 0.04 0.08 0.44];
% %t4_array = [.0 0.04 0.08 0.44];
% %t2_array = 0.3;
% t2_array = 0.1; %for water
% % t2_array = 0.2; %roughly like expts so far
% %t2_array = 10;
% t4_array = t2_array;
% n_t2_array = length(t2_array);
% 
% %for an exponential c2(t)
% %dt = 2*0.0021108; %ps
% dt = 0.03;
% n_t = 64; %number of time steps
% w_0 = 0; %center frequency
% range = [-600 400];
% labels = [-400:200:400];
% %range = [-200 200];
% %labels = [-150:150:150];
% anh = 162;
% two_level_system = false;
% %two_level_system = true;
% 
% %details of fft
% %fft_type = 'fft';
% %fft_type = 'petersfft';
% fft_type = 'sgrsfft';
% n_interp = 1; %number of points of linear interpolation to use
% n_zp = 1*n_t; %total length after zeropadding 
%             %(make n_zp=n_t for no zero padding)
% n_under = 0;
% 
% apodization = 'none';
% %apodization = 'triangular';
% %apodization = 'gaussian';
% 
% %type of projection to calculate
% %projection_type = 'window';
% projection_type = 'all';
% 
% % play with phase shifts
% phi = 0; %phase shift in deg
% noise = 0.0;
% 
% % simulate laser bandwidth
% simulate_bandwidth = false;
% %simulate_bandwidth = true;
% bandwidth = 180; %cm-1 fwhm
% bandwidth_axes = 2; %2 for scaled by LO spectrum, 3 for without

%-------------------------------------------------------------
%
% start calculation
%
%-------------------------------------------------------------
c = 2.9979e10;
wavenumbersToInvPs=c*1e-12;
invPsToWavenumbers=1/wavenumbersToInvPs;
c_cmfs = c*1e-15;
t=[0:(n_t-1)].*dt;
w = fftFreqAxis(t,...
  'time_units','ps',...
  'freq','wavenumbers',...
  'shift','on',...
  'zeropad',n_zp,...
  'undersampling',n_under);

dw = w(2)-w(1);
w_0 = w_0_cm*2*pi*wavenumbersToInvPs; %convert to radians

phi = phi*pi/180;
anh = anh*2*pi*wavenumbersToInvPs;
Delta = Delta_cm*wavenumbersToInvPs*2*pi;%apparently this is in
                                         %radians/s not just Hz...
Lambda = 1/tau;
disp(['Delta / Lambda = ',num2str(Delta/Lambda)]);
disp(['Delta = ',num2str(Delta),' ps^-1']);
disp(['Lambda = ',num2str(Lambda),' ps^-1']);

if ~exist('orientational_response','var')
  %if it is not defined then assume you don't care
  orientational_response = false;
end
if orientational_response
  disp('Using orentational response functions');
else
  disp('No orentational response functions');
end
  
switch damping,
  case 'overdamped'
    %overdamped exp(-t/tau)
    g = @(t) Delta^2/Lambda^2.*(exp(-Lambda.*abs(t))-1+Lambda.*abs(t));
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
  S = exp(-g(t)).*cos(w_0.*t);
  S2 = exp(-g(t)).*cos(w_0.*t).*(2-2*exp(-sqrt(-1)*anh.*t));
  
  switch fft_type
    case 'fft'
      disp('fft')
      S = fftshift(real(fft(S)));
      S2 = fftshift(real(fft(S2)));
    case 'petersfft'
      disp('peter''s fft')
      S  = fftshift(real(petersfft(S,n_interp)));
      S2 = fftshift(real(petersfft(S2,n_interp)));
    case 'sgrsfft'
      disp('sgr''s fft')
      S  = fftshift(real(sgrsfft(S)));
      S2 = fftshift(real(sgrsfft(S2)));
  end
end

if order>=3
  P = cell(1,n_t2_array);
  if two_level_system
    pump_probe = S;
  else
    pump_probe = S2;
  end
  [T1,T3] = meshgrid(t,t);
  for i=1:n_t2_array
    t2 = t2_array(i);
    %letting P1 and P2 be complex seems to work
    %    P1=fft2(exp(sqrt(-1)*w_0.*(-T1+T3)).*exp(-g(T1+phi)+g(t2)-g(T3)-g(T1+phi+t2)-g(t2+T3)+g(T1+phi+t2+T3)).*(2-2.*exp(-sqrt(-1)*anh.*T3)));
    %    P2=fft2(exp(sqrt(-1)*w_0.*(T1+T3)).*exp(-g(T1-phi)-g(t2)-g(T3)+g(T1-phi+t2)+g(t2+T3)-g(T1-phi+t2+T3)).*(2-2.*exp(-sqrt(-1)*anh.*T3)));
    %taking the real part also seems to work
    %    P1=fft2(real(exp(sqrt(-1)*w_0.*(-T1+T3)).*exp(-g(T1+phi)+g(t2)-g(T3)-g(T1+phi+t2)-g(t2+T3)+g(T1+phi+t2+T3)).*(2-2.*exp(-sqrt(-1)*anh.*T3))));
    %    P2=fft2(real(exp(sqrt(-1)*w_0.*(T1+T3)).*exp(-g(T1-phi)-g(t2)-g(T3)+g(T1-phi+t2)+g(t2+T3)-g(T1-phi+t2+T3)).*(2-2.*exp(-sqrt(-1)*anh.*T3))));
    if two_level_system
        disp('two level system')
        P1=real(exp(-1i*w_0.*(-T1+T3)+1i*phi).*exp(-g(T1)+g(t2)-g(T3)-g(T1+t2)-g(t2+T3)+g(T1+t2+T3)));
        P2=real(exp(-1i*w_0.*(T1+T3)+1i*phi).*exp(-g(T1)-g(t2)-g(T3)+g(T1+t2)+g(t2+T3)-g(T1+t2+T3)));
        PP=exp(1i*w_0.*(-T1+T3)+1i*phi).*exp(-g(T1)+g(t2)-g(T3)-g(T1+t2)-g(t2+T3)+g(T1+t2+T3))...
          ... % + real(exp(-1i*w_0.*(T1+T3)+1i*phi).*exp(-g(-T1)+g(t2)-g(T3)-g(-T1+t2)-g(t2+T3)+g(-T1+t2+T3)))...
           + exp(1i*w_0.*(-T1+T3)+1i*phi).*exp(-g(T1)-g(t2)-g(T3)+g(T1+t2)+g(t2+T3)-g(T1+t2+T3))...
          ...% + exp(-1i*w_0.*(-T1+T3)+1i*phi).*exp(-g(T1)-g(t2)-g(T3)+g(T1+t2)+g(t2+T3)-g(T1+t2+T3))...
          ;
        %PP = real(PP);
        P1_t = P1;
        P2_t = P2;
        PP_t = PP;

    else
        disp('multilevel system')
        %P1=real(exp(1i*w_0.*(-T1+T3)+1i*phi).*exp(-g(T1)+g(t2)-g(T3)-g(T1+t2)-g(t2+T3)+g(T1+t2+T3)).*(2-2.*exp(-sqrt(-1)*anh.*T3)));
        %P2=real(exp(1i*w_0.*(T1+T3)+1i*phi).*exp(-g(T1)-g(t2)-g(T3)+g(T1+t2)+g(t2+T3)-g(T1+t2+T3)).*(2-2.*exp(-sqrt(-1)*anh.*T3)));
        P1=exp(1i*w_0.*(-T1+T3)+1i*phi).*exp(-g(T1)+g(t2)-g(T3)-g(T1+t2)-g(t2+T3)+g(T1+t2+T3)).*(2-2.*exp(-sqrt(-1)*anh.*T3));
        P2=exp(1i*w_0.*(T1+T3)+1i*phi).*exp(-g(T1)-g(t2)-g(T3)+g(T1+t2)+g(t2+T3)-g(T1+t2+T3)).*(2-2.*exp(-sqrt(-1)*anh.*T3));
        PP=0.*exp(1i*w_0.*(-T1+T3)+1i*phi).*exp(-g(T1)+g(t2)-g(T3)-g(T1+t2)-g(t2+T3)+g(T1+t2+T3)).*(2-2.*exp(-sqrt(-1)*anh.*T3)) + ...
          ... % + exp(1i*w_0.*(-T1+T3)+1i*phi).*exp(-g(-T1)+g(t2)-g(T3)-g(-T1+t2)-g(t2+T3)+g(-T1+t2+T3)).*(2-2.*exp(-sqrt(-1)*anh.*T3)) ...
          + exp(1i*w_0.*(T1+T3)+1i*phi).*exp(-g(T1)-g(t2)-g(T3)+g(T1+t2)+g(t2+T3)-g(T1+t2+T3)).*(2-2.*exp(-sqrt(-1)*anh.*T3))...
          ... % + exp(1i*w_0.*(-T1+T3)+1i*phi).*exp(-g(-T1)-g(t2)-g(T3)+g(-T1+t2)+g(t2+T3)-g(-T1+t2+T3)).*(2-2.*exp(-sqrt(-1)*anh.*T3))...
          ;
        %PP = real(PP);
        P1_t = P1;
        P2_t = P2;
        PP_t = PP;

    end
    if orientational_response
      r = orientationalResponse(tau_R,3,T1,t2,T3);
      P1 = P1.*r;
      P2 = P2.*r;
    end
      
    switch lower(apodization)
      case 'triangular'
        disp('triangular apodization')
        x = 1:-1/(n_t-1):0;
        window_fxn = zeros(n_t,n_t);
        for j=1:n_t,
          for k = 1:n_t
            window_fxn(j,k) =x(j)*x(k);
          end
        end
        P1 = P1.*window_fxn;
        P2 = P2.*window_fxn;
      case {'gauss','gaussian'}
        disp('gaussian apodization')
        window_fxn = exp(-(T1.^2+T3.^2)./(2*(n_t*dt/2)^2));
        P1 = P1.*window_fxn;
        P2 = P2.*window_fxn;        
      case 'none'
        disp('no apodization')
    end
    if noise>0 
      P1 = P1+max(max(real(P1)))*noise.*rand(size(P1));
      P2 = P2+max(max(real(P2)))*noise.*rand(size(P2));
    end
    if flag_plot
     figure(1),clf
     my2dPlot(t,t,real(P1),12)
     figure(2),clf
     my2dPlot(t,t,real(P2),12)
    end
     x = real(P1);
    
    %do fft
    switch fft_type
      case 'fft'
        P1 = fft2(P1,n_zp,n_zp);
        P2 = fft2(P2,n_zp,n_zp);
        PP = fft2(PP,n_zp,n_zp);
      case 'petersfft'
        P1=petersfft2(P1,n_interp);
        P2=petersfft2(P2,n_interp);
        PP=petersfft2(PP,n_interp);
      case 'sgrsfft'
        P1=sgrsfft2(P1,n_zp);
        P2=sgrsfft2(P2,n_zp);
        PP=sgrsfft2(PP,n_zp);
    end
    P{i}=fftshift(real(fliplr(circshift(P1,[0 -1]))+P2));
    PP = real(fliplr(circshift(PP,[0 -1])));
    
    %simulate laser bandwidth
    if simulate_bandwidth
      disp(['2D simulating laser bandwidth ' num2str(bandwidth) ' cm-1 fwhm, for ' num2str(bandwidth_axes-1) ' axis' ]);
      [W1,W3]=meshgrid(w);
      switch bandwidth_axes
        case 3
          BW = exp(-((W1-w_0)+(W3-w_0)).^2 ...
            ./(2*(bandwidth/2.355)^2));
        case 2
          BW = exp(-(W1-w_0).^2 ...
            ./(2*(bandwidth/2.355)^2));
      end
      P{i} = P{i}.*BW;
    else
      disp('2D not simulating bandwidth');
    end

  end %end t2_array loop
end %end if order 3

if order>=5
  R = cell(1,n_t2_array);
  for i = 1:n_t2_array
    %set up the time variables
  [T1,T3,T5] = meshgrid(t,t,t);
  t2 = t2_array(i);
  t4 = t4_array(i);

  %cumulant expansion results for response functions
  if two_level_system 
    R1 =exp(1i*w_0.*(T1+T3+T5)+1i*phi).*...
      exp(-g(T1)-g(t2)-g(T3)-g(t4)-g(T5) ...
      +g(T1+t2)+g(t2+T3)+g(T3+t4)+g(t4+T5) ...
      -g(T1+t2+T3)-g(t2+T3+t4)-g(T3+t4+T5) ...
      +g(T1+t2+T3+t4)+g(t2+T3+t4+T5) ...
      -g(T1+t2+T3+t4+T5));
    R2 =exp(1i*w_0.*(-T1+T3+T5)+1i*phi).*...
      exp(-g(T1)+g(t2)-g(T3)-g(t4)-g(T5) ...
      -g(T1+t2)-g(t2+T3)+g(T3+t4)+g(t4+T5) ...
      +g(T1+t2+T3)+g(t2+T3+t4)-g(T3+t4+T5) ...
      -g(T1+t2+T3+t4)-g(t2+T3+t4+T5) ...
      +g(T1+t2+T3+t4+T5));
    R3 =exp(1i*w_0.*(T1-T3+T5)+1i*phi).*...
      exp(-g(T1)+g(t2)-g(T3)+g(t4)-g(T5) ...
      -g(T1+t2)-g(t2+T3)-g(T3+t4)-g(t4+T5) ...
      +g(T1+t2+T3)-g(t2+T3+t4)+g(T3+t4+T5) ...
      +g(T1+t2+T3+t4)+g(t2+T3+t4+T5) ...
      -g(T1+t2+T3+t4+T5));
    R4 =exp(1i*w_0.*(-T1-T3+T5)+1i*phi).*...
      exp(-g(T1)-g(t2)-g(T3)+g(t4)-g(T5) ...
      +g(T1+t2)+g(t2+T3)-g(T3+t4)-g(t4+T5) ...
      -g(T1+t2+T3)+g(t2+T3+t4)+g(T3+t4+T5) ...
      -g(T1+t2+T3+t4)-g(t2+T3+t4+T5) ...
      +g(T1+t2+T3+t4+T5));
  else
    R1 =exp(1i*w_0.*(T1+T3+T5)+1i*phi).*...
      exp(-g(T1)-g(t2)-g(T3)-g(t4)-g(T5) ...
      +g(T1+t2)+g(t2+T3)+g(T3+t4)+g(t4+T5) ...
      -g(T1+t2+T3)-g(t2+T3+t4)-g(T3+t4+T5) ...
      +g(T1+t2+T3+t4)+g(t2+T3+t4+T5) ...
      -g(T1+t2+T3+t4+T5)).* ...
      (4-8*exp(-1i*anh.*(T3+T5)) ...
      -4*exp(-1i*anh.*T5) ...
      +6*exp(-1i*anh.*(T3+2*T5)) ...
      +2*exp(-1i*anh*T3));
    R2 =exp(1i*w_0.*(-T1+T3+T5)+1i*phi).*...
      exp(-g(T1)+g(t2)-g(T3)-g(t4)-g(T5) ...
      -g(T1+t2)-g(t2+T3)+g(T3+t4)+g(t4+T5) ...
      +g(T1+t2+T3)+g(t2+T3+t4)-g(T3+t4+T5) ...
      -g(T1+t2+T3+t4)-g(t2+T3+t4+T5) ...
      +g(T1+t2+T3+t4+T5)).* ...
      (4-8*exp(-1i*anh.*(T3+T5)) ...
      -4*exp(-1i*anh.*T5) ...
      +6*exp(-1i*anh.*(T3+2*T5)) ...
      +2*exp(-1i*anh*T3));
    R3 =exp(1i*w_0.*(T1-T3+T5)+1i*phi).*...
      exp(-g(T1)+g(t2)-g(T3)+g(t4)-g(T5) ...
      -g(T1+t2)-g(t2+T3)-g(T3+t4)-g(t4+T5) ...
      +g(T1+t2+T3)-g(t2+T3+t4)+g(T3+t4+T5) ...
      +g(T1+t2+T3+t4)+g(t2+T3+t4+T5) ...
      -g(T1+t2+T3+t4+T5)).* ...
      (4-8*exp(-1i*anh.*(T5-T3)) ...
      -4*exp(-1i*anh.*T5) ...
      +6*exp(-1i*anh.*(2*T5-T3)) ...
      +2*exp(1i*anh*T3));
    R4 =exp(1i*w_0.*(-T1-T3+T5)+1i*phi).*...
      exp(-g(T1)-g(t2)-g(T3)+g(t4)-g(T5) ...
      +g(T1+t2)+g(t2+T3)-g(T3+t4)-g(t4+T5) ...
      -g(T1+t2+T3)+g(t2+T3+t4)+g(T3+t4+T5) ...
      -g(T1+t2+T3+t4)-g(t2+T3+t4+T5) ...
      +g(T1+t2+T3+t4+T5)).* ...
      (4-8*exp(-1i*anh.*(T5-T3)) ...
      -4*exp(-1i*anh.*T5) ...
      +6*exp(-1i*anh.*(2*T5-T3)) ...
      +2*exp(1i*anh*T3));
  end
  
  % orientational contribution to dephasing
  if orientational_response
    r = orientationalResponse(tau_R,5,T1,t2,T3,t4,T5);
    R1 = R1.*r;
    R2 = R2.*r;
    R3 = R3.*r;
    R4 = R4.*r;
  end
  
  switch lower(apodization)
    case 'triangular'
      disp('3D triangular apodization')
      x = 1:-1/(n_t-1):0;
      window_fxn = zeros(n_t,n_t,n_t);
      for j=1:n_t,
        for k = 1:n_t
          for l = 1:n_t
            window_fxn(j,k,l) =x(j)*x(k)*x(l);
          end
        end
      end
      R1 = R1.*window_fxn;
      R2 = R2.*window_fxn;
      R3 = R3.*window_fxn;
      R4 = R4.*window_fxn;
    case {'gauss','gaussian'}
      disp('3D gaussian apodization')
      window_fxn = exp(-(T1.^2+T3.^2)./(2*(n_t*dt/2)^2));
      R1 = R1.*window_fxn;
      R2 = R2.*window_fxn;
      R3 = R3.*window_fxn;
      R4 = R4.*window_fxn;
    case 'none'
      disp('3D no apodization')
  end
  if noise>0
    R1 = R1+max(max(real(R1)))*noise.*rand(size(R1));
    R2 = R2+max(max(real(R2)))*noise.*rand(size(R2));
    R3 = R1+max(max(real(R3)))*noise.*rand(size(R3));
    R4 = R2+max(max(real(R4)))*noise.*rand(size(R4));
  end

  switch lower(fft_type)
    case 'fft'
      R1 = fftn(R1,[n_zp,n_zp,n_zp]);
      R2 = fftn(R2,[n_zp,n_zp,n_zp]);
      R3 = fftn(R3,[n_zp,n_zp,n_zp]);
      R4 = fftn(R4,[n_zp,n_zp,n_zp]);
    case 'petersfft'
      R1 = petersfft3(R1,n_interp);
      R2 = petersfft3(R2,n_interp);
      R3 = petersfft3(R3,n_interp);
      R4 = petersfft3(R4,n_interp);
    case 'sgrsfft'
      R1 = sgrsfft3(R1,n_zp);
      R2 = sgrsfft3(R2,n_zp);
      R3 = sgrsfft3(R3,n_zp);
      R4 = sgrsfft3(R4,n_zp);      
  end

  %do the flips
  R2 = flipdim(circshift(R2,[0 -1 0]),2);
  R3 = flipdim(circshift(R3,[-1 0 0]),1);
  R4 = flipdim(flipdim(circshift(R4,[-1 -1 0]),1),2);
  R{i} = fftshift(real(R1+R2+R3+R4));
  end %end t2_array loop
  
  if simulate_bandwidth
    disp(['3D simulating laser bandwidth ' num2str(bandwidth) ...
      ' cm-1 fwhm, for ' num2str(bandwidth_axes) ' axes' ]);
    [W1,W3,W5]=meshgrid(w);
    if bandwidth_axes == 3
      BW = exp(-((W1-w_0)+(W3-w_0)+(W5-w_0)).^2./(2*(bandwidth/2.355)^2));
    elseif bandwidth_axes == 2
      BW = exp(-((W1-w_0)+(W3-w_0)).^2./(2*(bandwidth/2.355)^2));
    end      
    R{i} = R{i}.*BW;
  else
    disp('3D not simulating bandwidth');
  end
  
end %end if order 5

% trim stupid first frequency point...
w = w(2:end);
if order>=1,S = S(2:end);end
if order>=3,for i = 1:n_t2_array,P{i}=P{i}(2:end,2:end);pump_probe=pump_probe(2:end);end,end
if order>=5,for i = 1:n_t2_array,R{i}=R{i}(2:end,2:end,2:end);end,end
disp('done')

% Here are some of the ways to plot figures:
% %%
% figure(10)
% ind = find(w>=range(1)&w<=range(2));
% for i = 1:n_t2_array,
%   clf
%   my3dPlot2(w(ind),w(ind),w(ind),R{i}(ind,ind,ind),'labels',labels)
%   if n_t2_array>1,pause,end
% end
% 
% %%
% 
% return
% %%
% 
% figure(1)
% subplot(1,2,1)
% plot(t,g(t))
% title('lineshape function g')
% xlabel('t / ps')
% %set(gca,'Xlim',[0 5*tau]);
% subplot(1,2,2)
% plot(t,exp(-g(t)))
% xlabel('t / ps')
% title('exp(-g)')
% %set(gca,'Xlim',[0 5*tau]);
% 
% 
% figure(6),clf
% %offset_3d= R1(1,1,1);
% %R1=R1-offset_3d;
% my3dPlot(w,real(fftshift(R1(2:end,2:end,2:end))))
% 
% figure(7),clf
% %offset_3d = R2(1,1,1);
% %R2=R2-offset_3d;
% my3dPlot(w,real(fftshift(R2(2:end,2:end,2:end))))
% 
% figure(8),clf
% %offset_3d = R3(1,1,1);
% %R3=R3-offset_3d;
% my3dPlot(w,real(fftshift(R3(2:end,2:end,2:end))))
% 
% figure(9),clf
% %offset_3d = R4(1,1,1);
% %R4=R4-offset_3d;
% my3dPlot(w,real(fftshift(R4(2:end,2:end,2:end))))
% 
% 
% %%
% figure(2),clf
% norm_1d = trapz(S)*dw;
% mean_1d = trapz(w.*S)*dw./norm_1d;
% [max_1d,i] = max(S);
% peak_1d = w(i)
% plot(w,S,'-o',[peak_1d peak_1d],[0 max_1d*1.2],'k')
% title('1d spec')
% xlabel('\omega')
% set(gca,'XLim',[-300 300]);
% 
% %%
% figure(10)
% for i = 1:n_t2_array,
%   clf
%   my3dPlot(w,R{i})
%   if n_t2_array>1,pause,end
% end
% 
% %%
% [dummy,ind1] = min((w+100).^2);
% [dummy,ind2] = min((w-100).^2);
% ind = 1:4;
% figure(11),clf
% my3dSlices(w,R,t2_array,t4_array,ind,ind1,ind2)
% 
% figure(12),clf
% my3dProjections(w,R,1)
% 
% %%
% figure(3),clf
% my2dPlot(w,w,fftshift(real(P1(2:end,2:end))),20)
% figure(4),clf
% my2dPlot(w,w,fftshift(real(P2(2:end,2:end))),20)
% figure(5),clf
% ind = find(w>range(1)&w<range(2));
% if isempty(ind), 
%   ind = 1:length(P{1});
% end
% for i = 1:n_t2_array,
%   clf
%   my2dPlot(w(ind),w(ind),P{i}(ind,ind),20);
%   if n_t2_array>1,pause,end
% end
% %%
% pump_probe(ind) = pump_probe(ind)./max(pump_probe(ind));
% for i = 1:n_t2_array,
%   switch projection_type
%     case 'window'
%       projection{i} = sum(P{i}(ind,ind),2);
%     case 'all'
%       projection{i} = sum(P{i},2);
%       projection{i} = projection{i}(ind);
%   end
%   projection{i} = projection{i}./max(projection{i});
% end
% figure(6),
% plot(w(ind),pump_probe(ind),'o',w(ind),projection{1})
% 
