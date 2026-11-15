%% Some generic initialisations

labels={'a) ','b) ','c) ','d) ','e) ','f) ','g) ','h) ','i) ','j) ','k) '};
%% =========================================================
% Making the figures
% =========================================================
switch fig_idx
    case 1
%% =========================================================
% Display the raw input results
% =========================================================
if option_plot_figure(1)==1
figure('Name','1 - Raw directional buoy motion');

idx=1:length(ts); % Indexes of the chunk of the time searies to plot

subplot(3,1,1);
plot(ts(idx),eta(idx),'LineWidth',1); % Plot the elevation in function of time
yline(0,'--'); % Plot the zero line
ylabel('Elevation (\eta, m)'); % Name the y-axis
xlabel('Time (ts, s)'); % Name the x-axis
title('a) Vertical elevation / heave (z-axis)'); % Title of the subplot
grid on; % Display the grid

subplot(3,1,2);
plot(ts(idx),e_north(idx),'LineWidth',1); % Plot the north-south displacement
yline(0,'--'); % Plot the zero line
ylabel('North-South (m)');
xlabel('Time (ts, s)');
title('b) Meridional/Latitudes displacement (y-axis)'); % Title of the subplot
grid on; % Display the grid

subplot(3,1,3);
plot(ts(idx),e_west(idx),'LineWidth',1); % Plot the west-east displacement
yline(0,'--'); % Plot the zero line
ylabel('West-East (m)'); % Name the y-axis
xlabel('Time (ts, s)'); % Name the x-axis
title('c) Zonal/Longitudes displacement (x-axis)'); % Title of the subplot
grid on; % Display the grid
end
    case 2
%% =========================================================
% Select and display a single point
% =========================================================
if option_plot_figure(2)==1
figure('Name','2.i - Angle illustration: the place of the point');

% Placing the point's information with respect to the origin
p=scatter(e,n,100,'xb'); % Actual point
p.LineWidth=2.5;
text(e-0.15, n+0.20, sprintf('POINT'),... % Marking the point
     'HorizontalAlignment','right', 'FontWeight','bold');
hold on; % Telling the plot to hold the information to add others
o=scatter(0,0,80,'kx'); % Origin
o.LineWidth=1.8;
quiver(0,0, e,n, 0, 'LineWidth',2,'MaxHeadSize',0.18); % Vector from origin to point
plot([e e], [0 n], '--r','LineWidth',1.2); % Projection onto x axis
text(e, -0.20,sprintf('x = %.1f m',e),... % Point coordinate onto x axis
    'HorizontalAlignment','center', 'VerticalAlignment','top','FontWeight','bold');
plot([0 e], [n n], '--m','LineWidth',1.2); % Projection onto y axis
text(0.15, n, sprintf('y = %.1f m',n),... % Point coordinate onto y axis
    'HorizontalAlignment','left','FontWeight','bold');

% Making the grid
xlim([-L L]); ylim([-L L]); % Setting the limits accordingly
plot([-L L],[0 0],'k','LineWidth',1.2); % Highlighting the x-axis
plot([0 0],[-L L],'k','LineWidth',1.2); % Highlighting the y-axis
text(L-0.25,0.15,'EAST (+)'); text(-L+0.05,0.15,'WEST (-)'); % Naming the x-axis
text(0.15,L-0.2,'NORTH (+)'); text(0.15,-L+0.15,'SOUTH (-)'); % Naming the y-axis
l=unique(round(-L:1:L)); xticks(l); yticks(l); % Setting the grid ticks accordingly
grid on; % Display the grid

% Placing the labels
xlabel('East coordinate x (m)'); ylabel('North coordinate y (m)');
title({
    'ORIGINAL CARTESIAN VECTOR'
    sprintf('(x,y) = (%.1f, %.1f) m',e,n)
    'The point is NORTH-WEST of the origin'
    });
end
    case 3
%% =========================================================
% Illustrating the transformations steps to obtain the final angle
% =========================================================
if option_plot_figure(3)==1
figure('Name','2.ii - Angle illustration: the steps of the angle transformations');
r = 0.9; % Mathematical angular arc

% Setting up the 4 figures
for i=1:4
    subplot(2,2,i);
    % Drawing the axes
    plot([-L L],[0 0],'k'); hold on; plot([0 0],[-L L],'k'); 
    % Setting up the grid for all subplots
    xlim([-L L]); ylim([-L L]); grid on;
    xlabel('East x (m)'); ylabel('North y (m)');
    % Placing our point and its link to the origin of the axis
    % Placing the point's information with respect to the origin
    scatter(e,n,100,'xb','LineWidth',2.5); % Actual point
    hold on; % Telling the plot to hold the information to add others
    scatter(0,0,80,'kx','LineWidth',1.8); % Origin
    quiver(0,0, e,n, 0, 'LineWidth',2,'MaxHeadSize',0.18); % Vector from origin to point
end

% STEP 1: phi = atan2(y,x)
% MATHEMATICAL CONVENTION:
% East  = 0
% North = pi/2
% West  = pi
% South = -pi/2
% Counterclockwise positive.
subplot(2,2,1);
title({
    'STEP 1 — Cartesian → mathematical angle'
    '\phi = atan2(y,x)'
    'Zero = East; counterclockwise positive'
    });

% Reference labels
text(0.15,L-L/10,'North = \pi/2');
text(0.15,-L+L/10,'South = -\pi/2'); 
text(L-L/10,0.15,'East = 0','HorizontalAlignment','right');
text(-L+L/10,0.15,'West = \pi');

% Ploting the angle and naming the values
a = linspace(0,phi,100); % Setting up an angular space
aLabel=phi/2;
plot(r*cos(a),r*sin(a),'r','LineWidth',2);
text(1.25*r*cos(aLabel),1.25*r*sin(aLabel),...
     sprintf('\\phi = %.2f rad\n= %.1f°',phi,rad2deg(phi)),...
     'Color','r','FontWeight','bold','HorizontalAlignment','center');

% STEP 2: theta2 = pi/2 - phi
% Change ZERO from East to North.
% Positive = clockwise.
% Values may still be negative.
subplot(2,2,2);
title({
    'STEP 2 — Move angular zero to North'
    '\theta_{raw} = \pi/2 - \phi'
    'Negative values are allowed'
    });

% Reference labels
text(0.15,L-L/10,'North = 0');
text(0.15,-L+L/10,'South = \pm\pi');
text(L-L/10,0.15,'East = +\pi/2','HorizontalAlignment','right');
text(-L+L/10,0.15,'West = -\pi/2');

% Ploting the angle and naming the values
a = linspace(pi/2,phi,100);
aLabel=((pi/2)+phi)/2;
plot(r*cos(a),r*sin(a),'r','LineWidth',2);
text(1.3*r*cos(aLabel), 1.3*r*sin(aLabel),...
     sprintf('\\theta_{raw} = %.2f rad\n= %.1f°',theta2,rad2deg(theta2)),...
     'Color','r', 'FontWeight','bold', 'HorizontalAlignment','center');
 
% STEP 3: thetar = mod(theta_raw,2*pi)
subplot(2,2,3);
title({
    'STEP 3 — Wrap into [0,2\pi)'
    '\theta_{rad} = mod(\theta_{raw},2\pi)'
    'Clockwise compass-style angle'
    });

% Reference labels
text(0.15,L-L/10,'North = 0');
text(0.15,-L+L/10,'South = \pi');
text(L-L/10,0.15,'East = \pi/2','HorizontalAlignment','right');
text(-L+L/10,0.15,'West = 3\pi/2');

% Ploting the angle and naming the values
a = linspace(pi/2,pi/2-thetar,100);
aLabel = pi/2 - 0.58*thetar; % label on the long clockwise arc
plot(r*cos(a),r*sin(a),'r','LineWidth',2);
text(1.35*r*cos(aLabel), 1.35*r*sin(aLabel),...
     sprintf('\\theta_{rad} = %.2f rad\n= %.1f°',thetar,rad2deg(thetar)),...
     'Color','r','FontWeight','bold','HorizontalAlignment','center');
 

% STEP 4: thetad=thetar*180/pi;
% radians -> degrees
% Physical direction has NOT changed.
subplot(2,2,4);
title({
    'STEP 4 — Radians → degrees'
    '\theta_{deg} = rad2deg(\theta_{rad})'
    sprintf('Final direction = %.1f°',thetad)
    });

% Reference labels
text(0.15,L-L/10,'North = 0°');
text(0.15,-L+L/10,'South = 180°');
text(L-L/10,0.15,'East = 90°','HorizontalAlignment','right');
text(-L+L/10,0.15,'West = 270°');

% Ploting the angle and naming the values
a = linspace(pi/2,pi/2-thetar,100);
aLabel = pi/2 - 0.58*thetar;
plot(r*cos(a),r*sin(a),'r','LineWidth',2);
text(1.35*r*cos(aLabel),1.35*r*sin(aLabel),...
     sprintf('\\theta = %.1f°',thetad),...
     'Color','r','FontWeight','bold','HorizontalAlignment','center');
end        
    case 4
%% =========================================================
% Basic statistics on the elevation
% =========================================================
if option_plot_figure(4)==1
figure('Name','3 - Basic statistics on the elevation');

% Initialisation
e_mean   = e_stat(1);
e_std    = e_stat(2);
e_min    = e_stat(3);
e_max    = e_stat(4);
e_mode   = e_stat(5);
e_median = e_stat(6);
e_kurt   = e_stat(7);
e_skew   = e_stat(8);

% Temporal domain setting up
subplot(2,1,1); 
plot(eta); hold on;

% Temporal domain direct-stats display
yline(e_mean,'--',sprintf('Mean = %.2f',e_mean),'LineWidth',1.4,...
    'LabelHorizontalAlignment','left');
yline(e_median,'-.',sprintf('Median = %.2f',e_median),'LineWidth',1.4);
yline(e_mode,':', sprintf('Mode = %.2f',e_mode),'LineWidth',1.4);

% Temporal domain standard deviation: the top and bottom limits
yline(e_mean-e_std,'--g',sprintf('-STD = %.2f',e_mean-e_std),'LineWidth',1,'LabelHorizontalAlignment','left');
yline(e_mean+e_std,'--m',sprintf('+STD = %.2f',e_mean+e_std),'LineWidth',1,'LabelHorizontalAlignment','left');

% Temporal domain: min and max
yline(e_min,'b','LineWidth',1.4);
yline(e_max,'r','LineWidth',1.4);

% Temporal domain: Locate min and max, place them, and name them
[~,idx_min] = min(eta); 
[~,idx_max] = max(eta);
scatter(idx_min,e_min,8,'vb');
scatter(idx_max,e_max,8,'^r');
text(idx_min,e_min,sprintf('  Min = %.2f',e_min),'Color','b','VerticalAlignment','top');
text(idx_max,e_max,sprintf('  Max = %.2f',e_max),'Color','r','VerticalAlignment','bottom');

% Temporal domain: Placing the labels and grid
xlabel('Time (s)'); ylabel('Elevation (m)');
title('a) Temporal evolution of surface elevation \eta')
grid on;

% Distribution domain setting up
subplot(2,1,2);

% Compute histogram as a probability density
[p_eta,edges] = histcounts(eta,'Normalization','pdf','BinMethod','fd');
eta_bins = (edges(1:end-1) + edges(2:end))/2; % % Centre of each histogram bin

% Plot histogram distribution as a curve
plot(eta_bins,p_eta,'LineWidth',1.5);

% Distribution domain direct-stats display
xline(e_mean,'--',sprintf('Mean = %.2f',e_mean),'LineWidth',1.5,'LabelVerticalAlignment','bottom');
xline(e_median,'-.',sprintf('Median = %.2f',e_median),'LineWidth',1.5);
xline(e_mode,':',sprintf('Mode = %.2f',e_mode),'LineWidth',1.5);

% Distribution domain standard deviation: the top and bottom limits
xline(e_mean-e_std,'--g',sprintf('-STD = %.2f',e_mean-e_std),'LabelVerticalAlignment','bottom');
xline(e_mean+e_std,'--m',sprintf('+STD = %.2f',e_mean+e_std),'LabelVerticalAlignment','bottom');

% Distribution domain: min and max
xline(e_min,'b',sprintf('Min = %.2f',e_min),'LineWidth',1,'LabelVerticalAlignment','bottom');
xline(e_max,'r',sprintf('Max = %.2f',e_max),'LineWidth',1,'LabelVerticalAlignment','bottom');

% Distribution domain: Remaining stats
annotation("textbox",String=[["Kur = ",num2str(round(e_kurt,3))] ["Skew = ",num2str(round(e_skew,3))]]);

% Distribution domain: Placing the labels and grid
ylabel('Probability density (s)'); xlabel('Elevation (m)');
title('b) Distribution of surface elevation \eta')
grid on;
end
    case 5
%% =========================================================
% Zero crossing & H statistics
% =========================================================
if option_plot_figure(5)==1
figure('Name','4 - Individual waves and H_1/3','Color','w');

% Representation of the zero-crossing information
subplot(2,1,1); 
y0=yline(0,'--'); % placing the origin
hold on;

% Show the first 100 s and identified crossings / extrema.
tEnd = find(ts<=ts(1)+100);%1:min(1+100,N); % if the time series is shorter than 100, we stop before
te=plot(ts(tEnd),etat_zero_crossing(tEnd),'LineWidth',1.2); % Elevation 

% Taking the indexes of each wave chunk and display their information
idx = tCross<max(ts(tEnd)); 
o=scatter(tCross(idx),zeros(sum(idx),1),50,'ok','LineWidth',2); % Crossing periods
idx = tCrest<max(ts(tEnd)); 
c=scatter(tCrest(idx),crest(idx),50,'^r','LineWidth',2); % Crests
idx = tTrough<max(ts(tEnd)); 
v=scatter(tTrough(idx),trough(idx),50,'vb','LineWidth',2); % Troughs

% Vertical position of the arrows, below the elevation signal
eta_min = min(etat_zero_crossing(tEnd));
eta_max = max(etat_zero_crossing(tEnd));
eta_range = eta_max - eta_min;

y_arrow = eta_min - 0.12*eta_range;
y_text1  = y_arrow + 0.20;
y_text2  = y_arrow - 0.05;

% Waves for which BOTH crossings are inside the displayed interval
idx_wave = find( ...
    tCross(1:end-1) >= min(ts(tEnd)) & ...
    tCross(2:end)   <= max(ts(tEnd)) );

for i = idx_wave(:)'

    % Beginning and end of wave i
    t1 = tCross(i);
    t2 = tCross(i+1);

    % Middle of the wave interval
    tm = (t1+t2)/2;

    % Double-headed arrow:
    % one arrow from middle -> left
    % one arrow from middle -> right
    quiver(tm,y_arrow,t1-tm,0,0,'k','LineWidth',1,'MaxHeadSize',0.25, 'HandleVisibility','off');
    quiver(tm,y_arrow,t2-tm,0,0,'k','LineWidth',1, 'MaxHeadSize',0.25,'HandleVisibility','off');

    % Wave label
    text(tm,y_text1,sprintf('[H=%.2fm,T=%.2fs]',H(i),TzWave(i)),'HorizontalAlignment','center','VerticalAlignment','top');
    text(tm,y_text2,sprintf('wave_{%d}',i),'HorizontalAlignment','center','VerticalAlignment','top');
end

% Extend vertical axis so arrows and labels remain visible
ylim([eta_min-0.30*eta_range,eta_max+0.10*eta_range]);

% Placing the labels and grid
xlabel('Time (s)'); ylabel('Elevation (\eta_{zero-crossing}, m)');
title('a) Zero-upcrossing wave identification')
legend([te,y0,o,c,v],...
    '\eta_{zero-crossing}(t)','mean level','upcrossing','crest','trough', ...
    'Location','best')
grid on;

% PDF of individual wave heights.
subplot(2,1,2);
p1=histogram(H,'Normalization','pdf','BinMethod','fd'); hold on
p2=plot(Hgrid,pRayleigh,'LineWidth',1.5);

% Information upon the calculation of the H1/3 of the highest waves
xline(Hcut,'--',sprintf('upper 1/3 starts ~ %.2f m',Hcut));
xline(Hs_H13,'-.',sprintf('H_{1/3}=%.2f m',Hs_H13));

% Legend
legend([p1,p2],'Empirical PDF','Rayleigh reference','Location','northeast')

% Placing the labels and grid
title('b) Time-domain wave statistics');
xlabel('Individual wave height (H,m)');
ylabel('Probability density');
title('Empirical wave-height PDF and significant-wave-height definitions');
grid on;

end
    case 6
%% =========================================================
% Harmonic analyses through trends
% =========================================================
if option_plot_figure(6)==1
figure('Name','5 - Harmonic analyses through trends');

% Setting some variables
[Tplot,idx] = sort(T_harm);
nb=1.5;

% Looping
for j = 1:3
    % Setting up the approach: which signal is being used
    switch j
        case 1; x=eta;
        case 2; x=eta_demeaned;
        case 3; x=eta_detrended;
    end
    H_harm=harmonics{j,1};
    
    % Setting the temporal domain part
    subplot(3,3,(j-1)*3+1);
    p1=plot(ts,x); hold on;
    
    % Plotting the different Hm0
    p4=yline(H13_harm(j,1)/2,'--k','LineWidth',nb);
    p5=yline(Hs_H13/2,':r','LineWidth',nb);
    
    % Adding the extra plots where needed
    switch j
        case 1
            p2=yline(e_stat(1),'--b','LineWidth',nb);
            p3=plot(ts,eta_pol,':g','LineWidth',nb);
            legend([p1,p2,p3,p4,p5],'\eta','mean','trend','H_{13-harm}/2','H_{1/3}/2','Location','southeast');
        case 2
            legend([p1,p4,p5],'\eta_{deam}','H_{13-harm}/2','H_{1/3}/2','Location','southeast');
        case 3
            p2=yline(Hm0_h/2,'--r','LineWidth',nb);
            legend([p1,p2,p4,p5],'\eta_{det}','H_{m0}/2','H_{13-harm}/2','H_{1/3}/2','Location','southeast');
    end
    
    % Time domain labels and grid
    title([labels{(j-1)*3+1},signal_names{j}]);
    ylabel('Elevation (m)');
    xlabel('Time (s)');
    grid on; xlim([min(ts),max(ts)]);
    
    % Setting the frequency domain part
    subplot(3,3,(j-1)*3+2);
    stem(Tplot,H_harm(idx),'Marker','none','LineWidth',0.8);
    hold on;
    
    % Frequency domain labels and grid
    title(sprintf('%s Associated Fourier harmonics\n',labels{(j-1)*3+2}));
    set(gca,'XScale','log'); grid on;
    xlabel('Harmonic period T_k = 1/f_k (s)');
    ylabel('Equivalent harmonic height H_k = 2a_k (m)');
    
    % PDF of individual wave heights.
    subplot(3,3,(j-1)*3+3);
    histogram(harmonics{j,1},'Normalization','pdf','BinMethod','fd'); hold on

    % Information upon the calculation of the H1/3 of the highest waves
    p1=xline(H13_harm(j,2),'--r',sprintf('upper 1/3-harm starts ~ %.2f m',H13_harm(j,2)),'LineWidth',nb);
    p2=xline(H13_harm(j,1),'-.r',sprintf('H_{13-harm}=%.2f m',H13_harm(j,1)),'LineWidth',nb);
    
    p3=xline(Hcut,'--k',sprintf('upper 1/3 starts ~ %.2f m',Hcut),'LineWidth',nb);
    p4=xline(Hs_H13,'-.k',sprintf('H_{1/3}=%.2f m',Hs_H13));
    
    if j==3
        p5=xline(Hm0_h,'-.b',sprintf('H_{m0}=%.2f m',Hm0_h),'LineWidth',nb);
        legend([p1,p2,p3,p4,p5],'H_{13-harm}_{cut}','H_{13-harm}',...
                                'H_{1/3}_{cut}','H_{1/3}',...
                                'H_{m0}/2','Location','north');
    else
        legend([p1,p2,p3,p4],'H_{13-harm}_{cut}','H_{13-harm}',...
                                'H_{1/3}_{cut}','H_{1/3}',...
                                'Location','north');
    end

    % Placing the labels and grid
    title([labels{(j-1)*3+1},'Associated H distribution']);
    xlabel('Individual wave height (H,m)');
    ylabel('Probability density');
    title('Empirical wave-height PDF and significant-wave-height definitions');
    grid on;
end
end
    case 7
%% =========================================================
% Spectrum-Frequency-Harmonics-Elevation
% =========================================================
if option_plot_figure(7)==1
figure('Name','6 - Spectrum-Frequency-Harmonics-Elevation');

% ---------------------------------------------------------
% Top-left: harmonics separated by angular frequency
% ---------------------------------------------------------
subplot(2,2,1);  hold off;

% Sum of selected harmonics at omega = 0
plot3(ti,zeros(size(ti)),eta_detrended(it),'k','LineWidth',1.7);
hold on;

% Ploting the selected individual harmonics
for k = 1:nShow
    ih = idx_show(k);
    plot3(ti,omega(ih)*ones(size(ti)),eta_comp(:,k),'LineWidth',1); 
end

% Project S_omega on the t=max(ti) wall; z is only a visual rescaling
Somega=Sf(1:end)/(2*pi); 
zmin=min(eta_detrended(it));  zmax=max(eta_detrended(it));
zSpec=zmin+(Somega/max(Somega))*(zmax-zmin); 
plot3(max(ti)*ones(size(omega)),omega,zSpec,'r','LineWidth',1.7);

% Artificial spectrum vertical axis
St=linspace(0,max(Somega),4); 
zt=zmin+(St/max(Somega))*(zmax-zmin);
plot3([max(ti) max(ti)],[omega_max omega_max],[zmin zmax],'k','HandleVisibility','off');
for q=1:length(St)
    plot3([max(ti) max(ti)],[0.98*omega_max omega_max],[zt(q) zt(q)],'k','HandleVisibility','off');
    text(max(ti),1.02*omega_max,zt(q),sprintf(' %.2g',St(q)));
end
text(max(ti),1.08*omega_max,zmax,'           S (m^2 s)','FontWeight','bold');

% Artificial eta axis
St=linspace(0,max(Somega),4); 
etat=linspace(min(eta_detrended(it)),max(eta_detrended(it)),4);%(St-min(St))/(max(St)-min(St))
zt=zmin+(St/max(Somega))*(zmax-zmin);
plot3([min(ti) min(ti)],[omega_min omega_min],[zmin zmax],'k','HandleVisibility','off');
for q=1:length(St)
    plot3([min(ti) min(ti)],[0.98*omega_min omega_min],[zt(q) zt(q)],'k','HandleVisibility','off');
    text(min(ti),1.02*omega_min,zt(q),sprintf(' %.2g',etat(q)));
end
text(min(ti),1.08*omega_min,zmax,'       \eta (m)','FontWeight','bold');

% Making the remaining labels and grid
title('a) Individual Fourier harmonics and their sum')
xlabel('Time t (s)');
ylabel('\omega (rad/s)'); ylim([omega_min,omega_max]);
ax=gca; ax.ZAxis.Visible='off';
grid on; 
view(220,25); % Providing a proper angle to the 3D graph

% ---------------------------------------------------------
% Bottom-left: demonstrate the effect of phase
% ---------------------------------------------------------
subplot(2,2,3); hold off;

% Initialisation with setting eta-detrended for reference
p1=plot(ti,eta_detrended(it),':','LineWidth',1);
hold on;

% Ploting the other "waves"
p2=plot(ti,eta_selected,'LineWidth',1.5);
p3=plot(ti,eta_zeroPhase,'--','LineWidth',1.5);

% Making the legend
legend([p1,p2,p3], ...
    'Complete detrended elevation', ...
    'Selected harmonics - original phases', ...
    'Same H and T - all phases = 0', ...
    'Location','best');


% Making the remaining labels and grid
title('bc) Effect of phase: H and T unchanged, elevation changes');
xlabel('Time (s)'); 
ylabel('\eta (m)');
grid on;

% ---------------------------------------------------------
% Top-right: The spectrum and associated standard shapes
% ---------------------------------------------------------
subplot(2,2,2); hold off;

% The hand-made spectrum
p1=plot(fS,S,'b','LineWidth',1.5); hold on
xline(fp_hand,'-k',sprintf('f_p=%.3f Hz, T_p=%.2f s',fp_hand,Tp_hand),'LineWidth',1);
xline(fe_hand,'-k',sprintf('f_e=%.3f Hz',fe_hand),'LineWidth',1,'LabelVerticalAlignment','bottom');

% The Matlab-based spectrum
p2=plot(fsM,Sf,'r','LineWidth',1.5);
if option_for_the_curious==1
p2o=plot(fsM,Sf_hand,'r','LineWidth',1.5);    
end

% Standard shapes
p3=plot(fs,S_J,'--g','LineWidth',1.4);
p4=plot(fs,S_B,':g','LineWidth',1.4);

% Legend
if option_for_the_curious==1
legend([p1,p2,p2o,p3,p4],'Spectrum_{hand}','Spectrum_{Matlab}','Same by hand','JONSWAP','Bretschneider');
else
legend([p1,p2,p3,p4],'Spectrum_{hand}','Spectrum_{Matlab}','JONSWAP','Bretschneider');
end

% Making the remaining labels and grid
title(sprintf('b) Spectrum: H_{m0}=%.2f m, T_e=%.2f s',Hm0_hand,Te_hand));
xlabel('Frequency [Hz]'); xlim([f_min,f_max]);
ylabel('S(f) [m^2/Hz]');
grid on;

% ---------------------------------------------------------
% Bottom-right: The modes of the spectrum
% ---------------------------------------------------------
subplot(2,2,4); hold off;

% The hand spectrum shape for the 2,1, and -1 moments
p1=plot(fs,(fS.^2).*S,':','LineWidth',1.2); hold on;
p2=plot(fs,S,':','LineWidth',1.2); 
p3=plot(fS(2:end),S(2:end)./fS(2:end),':','LineWidth',1.2); % starting from 2 to avoid division by zero

% The Matlab spectrum shape for the 2,1, and -1 moments
p4=plot(fsM,(fsM.^2).*Sf,'LineWidth',1.2); hold on;
p5=plot(fsM,Sf,'LineWidth',1.2); 
p6=plot(fsM(2:end),Sf(2:end)./fsM(2:end),'LineWidth',1.2); % starting from 2 to avoid division by zero

% Legend
legend([p1,p4,p2,p5,p3,p6],'f^2 S(f) contribution to m_{2}','Same for Matlab spectrum',...
    'S(f) contribution to m_0','Same for Matlab spectrum',...
    'S(f)/f contribution to m_{-1}','Same for Matlab spectrum','Location','best')

% Making the remaining labels and grid
title('d) What is integrated: m_0 = \int S df and m_{-1} = \int S/f df');
xlabel('Frequency [Hz]'); xlim([f_min,f_max]);
ylabel('Moment integrand');
grid on;
end
case 8
%% =========================================================
% Spectrum-Frequency-Harmonics-Elevation
% =========================================================
if option_plot_figure(8)==1
figure('Name','7 - Directional spectrum');

subplot(2,2,1); hold off;
plot(fsM(validDirection),thetaFrom(validDirection),'.-','LineWidth',1); hold on;
plot(fp,theta_p,'o','MarkerSize',7,'LineWidth',1.5);
yline(theta_m,'--',sprintf('\\theta_m = %.1f deg',theta_m));
ylim([0 360]);
yticks(0:45:360);
xlabel('Frequency [Hz]');
ylabel('Direction FROM [deg]');
grid on;
title('Mean direction as a function of frequency');

subplot(2,2,2); hold off;
polarplot(deg2rad(thetaFrom(validDirection)),fsM(validDirection),'LineWidth',1.5); hold on;
polarplot(deg2rad(theta_p),fp,'o','MarkerSize',7,'LineWidth',1.5);
ax=gca; ax.ThetaDir = 'clockwise'; ax.ThetaZeroLocation='top';
grid minor; 
title('Polar mean direction as a function of frequency');

subplot(2,2,3); hold off;
imagesc(dirFromDeg,fsM,Sdir_plot_deg);
axis xy;
xlim([0 360]);
xticks(0:45:360);
xlabel('Direction FROM [deg true]');
ylabel('Frequency [Hz]');
cb = colorbar;
xlabel(cb,'m^2/(Hz deg)');
grid on;
title('Directional frequency spectrum S(f,\theta) - visualization reconstruction');

subplot(2,2,4); hold off;
s=surf(repmat(dirFromDeg,length(fsM),1),repmat(fsM,1,length(dirFromDeg)),Sdir_plot_deg);
s.FaceAlpha=0.7;
s.EdgeColor = "none";
xlabel('Direction FROM [deg true]');
ylabel('Frequency [Hz]');
zlabel('Spectrum [m^2/(Hz deg)]');
cb = colorbar;
xlabel(cb,'m^2/(Hz deg)');
grid on;
title('Directional frequency spectrum S(f,\theta) - 3D visualization reconstruction');
end
end    
%% =========================================================
% clearing the space from non-useful figure variables
% =========================================================
clear l r i a aLabel p o; % Parameters from the figures
clear e_mean e_std e_min e_max e_mode e_median e_kurt e_skew;
clear plotEnd te o c v t1 t2 tm etat;
clear Tplot p1 p2 p3 p4 p5 p6 p2o St zt;
clear labels;
clear s cb ax;