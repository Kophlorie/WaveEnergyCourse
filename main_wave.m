%% 0) Clearing the space

clc; % Clear the command window
clear; % Clear the workspace
close all; % Close all the figures

option_plot_figure=[...
    1,... % 1 - Raw directional buoy motion
    1,... % 2.i - Angle illustration: the place of the point
    1,... % 2.ii - Angle illustration: the steps of the angle transformations
    1,... % 3 - Basic statistics over the elevation
    1,... % 4 - Zero crossing & H statistics
    1,... % 5 - Harmonic analyses through trends
    1,... % 6 - Spectrum-Frequency-Harmonics-Elevation
    1,... % 7 - Directional spectrum
]';
%% 1) Load and check input
% =========================================================
% As an illustrative example, the time series needs to be affected by a
% trend of at the very least ax+b polynomial degree level. Additionally,
% the elevation should spread with a somewhat realistic spread, although
% its mean, mode, and median, should have values a bit sparse.
% =========================================================

% Read the table
option_version=2;
if option_version==1
time_series=readtable('WaveData/example_directional_buoy_standard.txt');
else
time_series=readtable('WaveData/example_directional_buoy_realistic.txt');
end

% Extract variables
ts=time_series.time_s(:); % Time values
eta=time_series.elevation_m(:); % Elevation values
e_north=time_series.north_m(:); % North-positive all conventions
e_west=time_series.west_m(:); % West-positive directional-Waverider convention

% Additional variables
e_east=-e_west; % East-positive oceanographic convention
N=size(ts,1); % Number of time considered

% Making figure 1
fig_idx=1; wave_figures; % Display the raw input results

% Cleaning the code and ending
clear fig_idx;
fprintf('\n1) Load and check input Done!\n');
%% 2) Compute the direction of the wave
% =========================================================
% The trigonometric estimation of an angle from a point with a (x,y)
% coordinate is provided by theta=atan2(y,x)=atan(y/x); where the angle is
% taken from the "bottom-right" at 0° in the "up-left" direction for pi/2=90°.
% This is the anticlockwise directional convention.
% In the oceanographic convention, 0° is placed in the "up-north" direction
% and the positive angle is in the opposite direction: "down-righ", which
% is the clockwise direction.
% One main common aspect between both is the x is on the longitudes, so
% east/west, with east towards the right, giving the positive values; and y
% on the latitudes north/south, with north "upward", giving the positive
% values. It is important to note that up in this context is on the flat
% x-y plane and not over the z-axis, which is considered here for the
% elevation only.
% The mathematical angle of a point (x,y) is obtained with atan2(y,x).
% Unlike atan(y/x), atan2 preserves the quadrant and therefore the full angle.
% This illustrates the angular conventions; the actual wave direction is
% obtained later from the directional spectral analysis.
% =========================================================

% 1) get the mathematical angle in radient
phi_rad = atan2(e_north,e_east); % radians, mathematical angle
% Standard mathematical angle
% atan2(y,x)
% Result is in RADIANS
% 0       = East
% pi/2    = North
% pi      = West
% -pi/2   = South

% 2) get the radient angle in the oceanographic convention
theta_2pi = pi/2 - phi_rad; % radians, compass angle
% Convert to compass convention
% 0       = North
% pi/2    = East
% pi      = South
% 3*pi/2  = West

% 3) get the radient angle in ranges that avoid obtaining negative degrees
theta_rad = mod(theta_2pi,2*pi); % force into [0, 2*pi)

% 4) get the angle in degrees
theta=theta_rad*180/pi;

% =========================================================
% Setting up variables from the figures from the choice below

idx=[]; % You choose a line of the time series
ep=-2; np=1; % You choose a specific lat/lon point to see

% Initialising the figure variables according to the choice
if isempty(idx)
    e=ep; n=np; 
    phi=atan2(n,e); theta2=pi/2-phi;
    thetar=mod(theta2,2*pi);  thetad=thetar*180/pi;
else
    e=e_east(idx); n=e_north(idx);
    phi=phi_rad(idx); theta2=theta_2pi(idx);
    thetar=theta_rad(idx); thetad=theta(idx);
end
e=round(e,2); n=round(n,2); % To avoid having too many numbers after 0
L=max(abs([e,n]))+0.05; % Centralising the point in an axis

% Making the figures
fig_idx=2; wave_figures; % Select and display a single point
fig_idx=3; wave_figures; % Illustrating the transformations steps to obtain the final angle

% Cleaning the code and ending
clear idx ep np e n phi theta2 thetar thetad L fig_idx;
fprintf('\n2) Compute the direction of the wave Done!\n');
%% 4) Basic statistics

% Total statistics
e_stat=[mean(eta),std(eta),min(eta),max(eta),mode(eta),median(eta),kurtosis(eta),skewness(eta),var(eta)];

% Making the figures
fig_idx=4; wave_figures; % Basic statistics on the elevation

% Cleaning the code and ending
clear t i idx temp;
fprintf('\n4) Basic statistics Done!\n');
%% 5) Extraction of the wave height, H, and wave period, T
% =========================================================
% Time domain
% =========================================================

% Make sure the elevation is centered over zero
eta_demeaned = eta - e_stat(1); % Remove only the mean
eta_detrended = detrend(eta,'linear'); % Remove best-fitting straight line a*t + b

% Test the eta here
etat_zero_crossing=eta_detrended;

% Upward crossing of the mean level eta=0:
idxCross = find(etat_zero_crossing(1:end-1) <= 0 & etat_zero_crossing(2:end) > 0);
nWaves = numel(idxCross)-1;

% Linear interpolation gives a more accurate crossing time than simply
% using the nearest sample. The crossing time is the estimated instant when 
% the elevation passes through the reference level etat_zero_crossing=0 between two  
% sampled points. Because the exact crossing usually lies between samples,  
% we linearly interpolate between (t_i,eta_i) and (t_{i+1},eta_{i+1}), so:
% tc=t{i}-(etat_zero_crossing{i}*((t{i+1}-t{i})/(etat_zero_crossing{i+1}-etat_zero_crossing{i}))) leading here to:
tCross = ts(idxCross)-...
         etat_zero_crossing(idxCross).*...
(ts(idxCross+1)-ts(idxCross))./(etat_zero_crossing(idxCross+1)-etat_zero_crossing(idxCross));


% Initialisation of the variables
H = nan(nWaves,1);
TzWave = nan(nWaves,1);
crest = nan(nWaves,1);
trough = nan(nWaves,1);
tCrest = nan(nWaves,1);
tTrough = nan(nWaves,1);

% Obtaining the information for each wave
for iw = 1:nWaves
    ii = (idxCross(iw)+1):idxCross(iw+1);

    [crest(iw),ic] = max(etat_zero_crossing(ii));
    [trough(iw),it] = min(etat_zero_crossing(ii));

    H(iw) = crest(iw)-trough(iw);
    TzWave(iw) = tCross(iw+1)-tCross(iw);

    tCrest(iw) = ts(ii(ic));
    tTrough(iw) = ts(ii(it));
end

% Removing the nan
idx=~isnan(TzWave);
H=H(idx);
TzWave=TzWave(idx);
crest=crest(idx);
trough=trough(idx);
tCrest=tCrest(idx);
tTrough=tTrough(idx);

% Classical significant wave height H_1/3 approach
Hsorted = sort(H,'descend'); % Sorting the H from the highest to lowest
nThird = max(1,round(nWaves/3)); % Making sure the number of waves is larger than 3 waves
Hs_H13 = mean(Hsorted(1:nThird)); % Average the highest one-third
Hcut = Hsorted(nThird); % Approximate threshold entering the upper third
Tz = mean(TzWave); % Zero-crossing wave period

% =========================================================
% Extra variables for figures and comparison
% =========================================================
Hgrid = linspace(0,max(H)*1.10,300);
% Narrow-band Gaussian/Rayleigh reference based on Hs_H13:
% p(H)=4H/Hs_H13^2 * exp[-2(H/Hs_H13)^2]
pRayleigh = 4*Hgrid/Hs_H13^2 .* exp(-2*(Hgrid/Hs_H13).^2);

% Making the figures
fig_idx=5; wave_figures; % Harmonic analyses

% Cleaning the code and ending
clear iw ic it ii idx signals nThird;
fprintf('\n5) Extraction of the wave height, H, and wave period, T Done!\n');
%% 6) Extraction of the harmonique H and T
% =========================================================
% Frequency domain
% =========================================================

% Three approaches of the harmonics are being considered
signal_names = { ...
    'Original \eta(t)', ...
    'Demeaned \eta(t)', ...
    'Linearly detrended \eta(t)'};

% Computing the detrending by hand for comparison
polinom=polyfit(ts,eta,1); % Obtaining the 1st degree polynomial coefficients
eta_pol=polyval(polinom,ts); % Creating the trend
eta_detrended2=eta-eta_pol; % Detrending eta by hand
fprintf(['Detrended equation vs Matlab function difference = ',...
num2str(max(eta_detrended-eta_detrended2)),' ≈ ',num2str(round(max(eta_detrended-eta_detrended2),2)),'\n']);

% Allocating space to save the harmonics' information: 
% frequency (Hz) - f
% amplitude (m) - a
% phase (°) - o
% Such that each harmonic is presented as a*cos(2pi*f_harm*t+o)
% Each harmonic is represented as:
% a*cos(2*pi*f_harm*(ts-ts(1)) + phase)
idx_harm = 2:floor(N/2)+1; % Indices of positive-frequency harmonics
dt = mean(diff(ts));             % [s]
Fs = 1/dt;                       % sampling frequency [Hz]
f_harm=(Fs/N)*(1:floor(N/2))'; % harmonic frequencies

% Storage:
% harmonics{j,1} = equivalent harmonic heights H = 2a
% harmonics{j,2} = phase [deg]
harmonics=cell(3,2); % 3 approaches, 2 information remaining to save
% 1 = harmonic H_1/3
% 2 = H threshold entering upper third
H13_harm=zeros(3,2); % 3 approaches, variables: harmonique Hs_H13 and Hcut

% Looping to generate and save the harmonics
for j = 1:3
    
    % Setting up the approach: which signal is being used
    switch j
        case 1; x=eta;
        case 2; x=eta_demeaned;
        case 3; x=eta_detrended;
    end
    
    % Fourier transform
    Y = fft(x);
    
    % Amplitude treatment
    a2=abs(Y)/N;
    % A2 is symmetric because a real-valued signal has conjugate Fourier 
    % components at +f_harm and -f_harm, carrying the same amplitude. Indeed
    % a*cos(2pi*f_harm*t+o)=a*cos(2pi*(-f_harm)*t-o)
    % For a real-valued signal, the Fourier coefficients at +f_harm and -f_harm
    % are complex conjugates: same amplitude, opposite phase.
    % One-sided amplitude spectrum
    a=2*a2(idx_harm);
    % As such, a is already the full cosine amplitude of each 
    % positive-frequency real harmonic. Hence, a{k}*cos(2pi*f_harm{k}*t+phi{k})
    % has variance of (a{k}^2)/2.
    % Basically, the doubled one-sided amplitude is the physical cosine 
    % amplitude: (+f_harm,-f_harm) -> a*cos(2pi*f_harm*t+phi) with variance (a^2)/2.
    
    % If N is even, the last element is the Nyquist frequency.
    % It has no distinct negative-frequency partner, so do NOT double it.
    if rem(N,2)==0
        a(end) = a(end)/2;
    end
    
    % Equivalent regular-wave quantities
    H_harm=2*a;
    
    % Computing the hormonis H1/3
    Hsorted = sort(H_harm,'descend'); % Sorting the H from the highest to lowest
    nThird = max(1,round(length(H_harm)/3)); % Making sure the number of waves is larger than 3 waves
    H13_j = mean(Hsorted(1:nThird)); % Average the highest one-third
    Hcut_j = Hsorted(nThird); % Approximate threshold entering the upper third
    
    % Phase in degrees
    o = angle(Y(idx_harm))*180/pi;
    
    % Savings
    harmonics{j,1}=H_harm;
    harmonics{j,2} = o;
    H13_harm(j,:)=[H13_j,Hcut_j];
end

% Equivalent regular-wave quantities 
T_harm=1./f_harm;

% Obtaining the m0 from the harmonic analysis
% Over the 3 approaches we need to use the linearly detrended signal, 
% ideally also restricting to the wave-frequency band. 
% The raw and demeaned signals have the same nonzero Fourier harmonics 
% in theory; demeaning only removes the f_harm=0 DC term. 
% Linear detrending additionally removes low-frequency energy associated 
% with a slope/drift that you do not want interpreted as waves.
jm0=3;

% This combines the Fourier components energetically, rather than ranking their amplitudes.
if rem(N,2)==0 % Nyquist frequency case
% Initialisation
ah=harmonics{jm0,1}/2;
% All ordinary positive-frequency harmonics
m0_h = sum(ah(1:end-1).^2/2);
% Nyquist harmonic
m0_h = m0_h + ah(end)^2;
else % No Nyquist frequency
% Direct simple calsculation
m0_h=sum(((harmonics{jm0,1}/2).^2)/2);
end
Hm0_h=4*sqrt(m0_h);

% Making the figures
% Direct effect of the trends on the harmonic distributions
fig_idx=6; wave_figures; % Harmonic analyses through trends

% Cleaning the code and ending
clear j x Y H_harm a a2 Y H13_j jm0 ah fig_idx;
fprintf('\n6) Extraction of the harmonique H and T Done!\n');
%% 7) Spectrum, harmonis, and elevation results comparisons
% =========================================================
% Conducting the creation of the spectrum "by hand"
% =========================================================
% Frequency resolution
x=eta_detrended;
Y = fft(x); % FFT
df = Fs/N; % frequency resolution delta_f [Hz]  
fS = df*(0:floor(N/2))'; % complete non-negative frequency vector
fs=(Fs/N)*(0:floor(N/2))'; % harmonic frequencies

% Raw two-sided power spectral density
S2 = abs(Y).^2/(Fs*N); % [m^2/Hz]

% Keep non-negative frequencies
% DC do not double, ordinary+f bins->double, isolate the potential Nyquist element 
S = [S2(1);2*S2(2:floor(N/2));S2(floor(N/2)+1)];

% Convert to one-sided spectrum
if rem(N,2)~=0
    % Do not double DC
    S(end) = 2*S(end);
end
% Now (m^2)/Hz

% For the ordinary interior harmonics there is a very nice bridge 
% with the amplitude calculation: S(f_harm{i})=(a{i}^2)/(2*delta_f) because
% (1/2)a{i}^2 = S(f_harm{i})*delta_f, such that
% a{i}=sqrt(2S(f_harm{i})*delta_f) since H{i}_harmonique=2*a{i}:
idxS=2:(length(S)-1+rem(N,2));
idxH=1:length(idxS);
j=3; Hb=2*sqrt(2*S(idxS)*df);
fprintf(['H computed from scratch vs using S difference = ',...
num2str(max(harmonics{j,1}(idxH)-Hb)),' ≈ ',num2str(round(max(harmonics{j,1}(1:end-1)-Hb),2)),'\n']);
% Similarly from the opposite point of view, we have:
Sb=2*(((harmonics{j,1}(idxH))/4).^2)/df; % ~H.^2/(8*df) ≈ Sb=harmonics{j,1}(idxH).^2/(8*df);
fprintf(['S computed from scratch vs using H_{harm} difference = ',...
num2str(max(S(idxS)-Sb)),' ≈ ',num2str(round(max(S(idxS)-Sb),2)),'\n']);
fprintf(['FFT spectrum variance = ',num2str(sum(S)*df),...
    ' ; temporal variance = ',num2str(mean(x.^2)),...
    ' ; difference = ',num2str(abs((sum(S)*df)-mean(x.^2))),'\n']);
fprintf(['Hm0 FFT = ',num2str(4*sqrt(sum(S)*df)),...
    ' ; 4*std = ',num2str(4*std(x,1)),'\n']);

% Spectral moments
m0_hand = sum(S)*df;
mMinus1_hand = sum(S(2:end)./fS(2:end))*df;
m2_hand = sum((fS.^2).*S)*df;

% Spectral wave parameters
Hm0_hand = 4*sqrt(m0_hand);
Te_hand = mMinus1_hand/m0_hand;
fe_hand=1/Te_hand;
Tz_hand = sqrt(m0_hand/m2_hand);
fz_hand=1/Tz_hand;

% Spectral peak.
[~,ip] = max(S);
fp_hand = fS(ip);
Tp_hand = 1/fp_hand;

% =========================================================
% Bretschneider and JONSWAP equivalence
% =========================================================
% Appropriate angular frequency
omegaB = 2*pi*fs;
omega_p = 2*pi/Tp_hand;
% Bretschneider in angular-frequency form S_omega
S_B_omega = ...
(5/16)*Hm0_hand^2.* omega_p^4./omegaB.^5.*exp(-(5/4)*(omega_p./omegaB).^4);
S_B_omega(1)=0;
% JONSWAP
gamma = 3.3;
sigma = 0.07*ones(size(omegaB));
sigma(omegaB > omega_p) = 0.09;
peakShape = exp(-0.5*((omegaB-omega_p)./(sigma*omega_p)).^2 );
S_J_omega =(1-0.287*log(gamma)) .* S_B_omega .* gamma.^peakShape;
% Convert S_omega -> S_f
S_B = 2*pi*S_B_omega;
S_J = 2*pi*S_J_omega;

% =========================================================
% Conducting the creation of the spectrum through Matlab calculations
% =========================================================
option_for_the_curious=0;
% Welch settings.
% With Fs=2 Hz, 256 samples = 128 s segments.
L=min(256,N);
overlap = round(0.5*L);
step=L-overlap;
win = hann(L,'periodic');
U=sum(win.^2);

% Following eta_detrended, we do the same for the directional elements
e_north_detrended = detrend(e_north,'linear');
e_west_detrended  = detrend(e_west,'linear');

% Auto spectra.
[Sf,fsM] = pwelch(eta_detrended,  win,overlap,N,Fs); % heave elevation PSD [m^2/Hz]
[Cnn,~] = pwelch(e_north_detrended,win,overlap,N,Fs);
[Cww,~] = pwelch(e_west_detrended, win,overlap,N,Fs);

% Cross spectra. MATLAB cpsd uses the complex cross spectrum convention
% consistent with Pxy ~ conj(X).*Y, so imag(Pxy) supplies the quadrature
% spectrum Qxy in the coefficient equations used below.
[Pvn,~] = cpsd(eta_detrended,  e_north_detrended,win,overlap,N,Fs);
[Pvw,~] = cpsd(eta_detrended,  e_west_detrended, win,overlap,N,Fs);
[Pnw,~] = cpsd(e_north_detrended,e_west_detrended, win,overlap,N,Fs);

% Spectral moments m_n = int f_harm^n S(f_harm) df.
m0_M       = [trapz(fsM,Sf),sum(Sf)*df];
mMinus1_M = [trapz(fsM(2:end),Sf(2:end)./fsM(2:end)),sum(Sf(2:end)./fsM(2:end))*df];
m2_M  = [trapz(fsM,(fsM.^2).*Sf),sum((fsM.^2).*Sf)*df];

% Spectral wave parameters
Hm0_M = 4*sqrt(m0_M);
Te_M  = mMinus1_M./m0_M;
fe_M = 1./Te_M;
Tz_M  = sqrt(m0_M./m2_M);
fz_M = 1./Tz_M;

% Spectral peak.
[~,localPeak] = max(Sf);
fp = fsM(localPeak);
Tp = 1/fp;

if option_for_the_curious==1
% Initialisation of the Welch spectrum by hand
Sf_hand=zeros(floor(N/2)+1,1); % Sum/average of the spectra of all chunks
nseg=0;                        % Number of chunks considered
% Going through the signal by chunks of L points, overlapping by "overlap"
for i0=1:step:N-L+1
    % Extract one chunk of the detrended elevation
    x_temp=x(i0:i0+L-1);
    % Apply the Hann window to reduce discontinuities at the chunk edges
    x_temp=x_temp.*win;
    % FFT of the chunk
    % N is used so the final frequency vector is the same as for S
    Y_temp=fft(x_temp,N);
    % Two-sided PSD of this chunk
    % U=sum(win.^2) compensates for the energy modification caused by the window
    S_temp=abs(Y_temp).^2/(Fs*U);
    % Keep only the non-negative frequencies
    S_temp=S_temp(1:floor(N/2)+1);
    % Convert to one-sided spectrum:
    % ordinary +f components contain the contribution of their -f partners
    if rem(N,2)==0
        S_temp(2:end-1)=2*S_temp(2:end-1); % exclude DC and Nyquist
    else
        S_temp(2:end)=2*S_temp(2:end);     % exclude DC only
    end
    % Add this chunk spectrum to the others
    Sf_hand=Sf_hand+S_temp;
    nseg=nseg+1;
end
% Welch spectrum = average spectrum of all the chunks
Sf_hand=Sf_hand/nseg;
fprintf(['Full FFT variance = ',num2str(sum(S)*df),...
    ' ; Welch variance = ',num2str(sum(Sf_hand)*df),...
    ' ; Temporal variance = ',num2str(mean(x.^2)),'\n']);
% Spectral moments
% Spectral moments of the hand-made Welch spectrum
m0_whand = sum(Sf_hand)*df;
mMinus1_whand = sum(Sf_hand(2:end)./fS(2:end))*df;
m2_whand = sum((fS.^2).*Sf_hand)*df;
% Spectral wave parameters
Hm0_whand = 4*sqrt(m0_whand);
Te_whand = mMinus1_whand/m0_whand; 
fe_whand=1/Te_whand;
Tz_whand = sqrt(m0_whand/m2_whand); 
fz_whand=1/Tz_whand;
% Spectral peak.
[~,ip_whand]=max(Sf_hand); 
fp_whand=fS(ip_whand); 
Tp_whand=1/fp_whand;
end

% Hs, Te, Tp comparative table
obtain_the_comparative_table;
disp(comparison_table)

% =========================================================
% Extra variables for figures and comparison
% =========================================================
% Assessing the relationship between the spectrum, harmonics and elevation
j = 3; % linearly detrended approach
H_harm = harmonics{j,1}; % equivalent harmonic height [m]
o = harmonics{j,2}*pi/180; % phase: degrees -> radians
a = H_harm/2; % harmonic amplitude [m]
omega = 2*pi*fs; % angular frequency [rad/s]
% Time relative to beginning of record
t = ts-ts(1); % t-t0
% Remove DC and optionally select a small wave-frequency range
% show the harmonics covering the periods associated 
% with the physically relevant waves I expect at this location
% fMin=1/14.5; % Tp=14.5s is characteristic of large swells coming from the south
% fMax=1; % Tp=1s small waves with low energy or nearshore reach
% band = fS >= fMin & fS <= fMax;
% assert(any(band),'Chosen wave-frequency band is empty.');
% Select a wave-period range for illustration
Tmin = 2;      % [s]
Tmax = 25;     % [s]
idx_wave = find(T_harm >= Tmin & T_harm <= Tmax);
f_max=1/Tmin; omega_max=2*pi*f_max;
f_min=1/Tmax;
omega_min=0;%2*pi*f_min;
% Select the strongest harmonics within that range
nShow = min(8,length(idx_wave));
[~,ii] = sort(H_harm(idx_wave),'descend');
idx_show = idx_wave(ii(1:nShow));
% Sort selected harmonics by frequency for clearer 3-D display
[~,ii] = sort(f_harm(idx_show));
idx_show = idx_show(ii);
% Only display first part of record
it = t <= min(100,max(t));
ti = t(it);
% Reconstruct selected harmonics using REAL phases
eta_comp = zeros(length(ti),nShow);
for k = 1:nShow
    ih = idx_show(k);
    eta_comp(:,k) = a(ih)*cos(2*pi*f_harm(ih)*ti + o(ih));
end
eta_selected = sum(eta_comp,2);
% Same harmonics, but artificially force all phases to zero
eta_zeroPhase = zeros(length(ti),1);
for k = 1:nShow
    ih = idx_show(k);
    eta_zeroPhase = eta_zeroPhase+ a(ih)*cos(2*pi*f_harm(ih)*ti);
end
% Figure
fig_idx=7; wave_figures; % Spectrum-Frequency-Harmonics-Elevation

% Cleaning the code and ending
clear j k i ih it ti H_hamr o a omega t Tmin Tmax tmax_plot fig_idx Hb Sb;
clear idx_wave nShow idx_show eta_comp eta_selected eta_zeroPhase;
clear Somega zmin zmax zSpec;
fprintf('\n7) Spectrum, harmonis, and elevation results comparisons Done!\n');
%% 8) Directional Fourier Coefficients
% Waverider-style coefficients using vertical (v), North (n), West (w).
horizontalPower = Cnn + Cww;
den = sqrt(Sf .* horizontalPower);

a1 = nan(size(fsM));
b1 = nan(size(fsM));
a2 = nan(size(fsM));
b2 = nan(size(fsM));
K  = nan(size(fsM));  % horizontal/vertical orbital amplitude check factor

validDen = den > eps & horizontalPower > eps & Sf > eps;

Qvn = imag(Pvn);
Qvw = imag(Pvw);
Cnw = real(Pnw);

a1(validDen) = Qvn(validDen) ./ den(validDen);
b1(validDen) = Qvw(validDen) ./ den(validDen);
a2(validDen) = (Cnn(validDen)-Cww(validDen)) ./ horizontalPower(validDen);
b2(validDen) = 2*Cnw(validDen) ./ horizontalPower(validDen);

K(validDen) = sqrt(horizontalPower(validDen)./Sf(validDen));

% First directional moment magnitude.
R1 = hypot(a1,b1);

% Only trust direction where there is meaningful wave energy.
peakEnergy = max(Sf);
% Ignore directional estimates where heave spectral energy is negligible.
directionEnergyThreshold = 0.01;   % 1% of peak S(f)
validDirection = validDen & ...
    (Sf >= directionEnergyThreshold*peakEnergy);

% theta0 is the Datawell-style mathematical propagation angle:
%   0 = North, positive toward West.
theta0 = atan2(b1,a1);

% Convert propagation angle to oceanographic FROM direction:
% geographic TO bearing = -theta0
% FROM = TO + 180 => 180 - theta0(deg)
thetaFrom = mod(180-rad2deg(theta0),360);
thetaFrom(~validDirection) = NaN;

% Peak direction: mean direction of the first moment at the spectral peak.
theta_p = thetaFrom(localPeak);

% Overall mean direction: energy-weighted vector integration of a1,b1.
% Invalid/very-low-energy frequencies contribute zero.
a1w = zeros(size(fsM));
b1w = zeros(size(fsM));
a1w(validDirection) = a1(validDirection);
b1w(validDirection) = b1(validDirection);

Amean = trapz(fsM, Sf.*a1w);
Bmean = trapz(fsM, Sf.*b1w);

theta0_mean = atan2(Bmean,Amean);
theta_m = mod(180-rad2deg(theta0_mean),360);

% =========================================================
% Reconstruct an illustrative Spectrum
% =========================================================
% We evaluate the Fourier series on an oceanographic FROM-direction grid.
% Direction grid used for displaying S(f,theta).
dirFromDeg = 0:2:358;              % oceanographic FROM direction
dTheta = deg2rad(2);

% Internal theta corresponding to each FROM bearing:
% theta_internal = 180 deg - direction_from
thetaInternal = deg2rad(mod(180-dirFromDeg,360));

D_raw = nan(numel(fsM),numel(dirFromDeg));   % [rad^-1]
D_plot = nan(size(D_raw));                 % clipped/renormalized FOR PLOTTING

for jf = 1:numel(fsM)
    if ~validDirection(jf)
        continue
    end

    th = thetaInternal;

    % First two Fourier harmonics:
    D = (1/pi) * ( ...
          0.5 ...
        + a1(jf)*cos(th) ...
        + b1(jf)*sin(th) ...
        + a2(jf)*cos(2*th) ...
        + b2(jf)*sin(2*th) );

    D_raw(jf,:) = D;

    % Truncated Fourier reconstruction may be negative.
    % For an intuitive non-negative image only, clip and re-normalize.
    Dp = max(D,0);
    normDp = sum(Dp)*dTheta;
    if normDp > 0
        D_plot(jf,:) = Dp/normDp;
    end
end

% S(fsM,theta) [m^2/(Hz rad)] for the visualization copy.
Sdir_plot = Sf .* D_plot;

% Convert density from per radian to per degree ONLY for plotting on a
% degree axis: S_deg dtheta_deg = S_rad dtheta_rad.
Sdir_plot_deg = Sdir_plot * (pi/180);      % [m^2/(Hz deg)]

% Negative fraction in the raw Fourier reconstruction: useful diagnostic.
rawVals = D_raw(validDirection,:);
negativeFraction = 100*sum(rawVals(:)<0)/sum(isfinite(rawVals(:)));

fig_idx=8; wave_figures; % Directional spectrum

% Cleaning the code and ending
clear j k i ih it ti H_hamr o a omega t Tmin Tmax tmax_plot fig_idx Hb Sb;
clear idx_wave nShow idx_show eta_comp eta_selected eta_zeroPhase;
clear Somega zmin zmax zSpec;
fprintf('\n8)Directional Fourier Coefficients Done!\n');