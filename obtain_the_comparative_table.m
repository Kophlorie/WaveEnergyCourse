% Hs, Te, Tp comparative table
if option_for_the_curious==1
% Rows = parameters, columns = calculation approaches
comparison_values = [...
    Hs_H13, NaN,              NaN,              NaN,              NaN,       NaN,        NaN,       NaN;       % H1/3
    NaN,     H13_harm(1,1),   H13_harm(2,1),   H13_harm(3,1),   NaN,       NaN,        NaN,       NaN;       % experimental harmonic H1/3
    Hcut,    H13_harm(1,2),   H13_harm(2,2),   H13_harm(3,2),   NaN,       NaN,        NaN,       NaN;       % upper-third threshold
    NaN,     NaN,              NaN,              Hm0_h,            Hm0_hand,  Hm0_whand,  Hm0_M(1), Hm0_M(2); % Hm0
    Tz,      NaN,              NaN,              NaN,              Tz_hand,   Tz_whand,   Tz_M(1),  Tz_M(2);  % Tz
    1/Tz,    NaN,              NaN,              NaN,              fz_hand,   fz_whand,   fz_M(1),  fz_M(2);  % fz
    NaN,     NaN,              NaN,              NaN,              Te_hand,   Te_whand,   Te_M(1),  Te_M(2);  % Te
    NaN,     NaN,              NaN,              NaN,              fe_hand,   fe_whand,   fe_M(1),  fe_M(2);  % fe
    NaN,     NaN,              NaN,              NaN,              Tp_hand,   Tp_whand,   Tp,       Tp;       % Tp
    NaN,     NaN,              NaN,              NaN,              fp_hand,   fp_whand,   fp,       fp;       % fp
    NaN,     NaN,              NaN,              m0_h,             m0_hand,   m0_whand,   m0_M(1),  m0_M(2);  % m0
    NaN,     NaN,              NaN,              NaN,              mMinus1_hand,mMinus1_whand,mMinus1_M(1),mMinus1_M(2); % m-1
    NaN,     NaN,              NaN,              NaN,              m2_hand,   m2_whand,   m2_M(1),  m2_M(2)]; % m2

comparison_table = array2table(comparison_values,...
    'VariableNames',{'ZeroCrossing','Harm_Original','Harm_Demeaned',...
    'Harm_Detrended','FFT_Hand','Welch_Hand','Pwelch_Trapz','Pwelch_Sum'},...
    'RowNames',{'H1_3_m','H13_harm_m','Hcut_m','Hm0_m',...
    'Tz_s','fz_Hz','Te_s','fe_Hz','Tp_s','fp_Hz',...
    'm0_m2','mMinus1_m2s','m2_m2Hz2'});
else
% Rows = parameters, columns = calculation approaches
comparison_values = [...
    Hs_H13, NaN,              NaN,              NaN,              NaN,       NaN,       NaN;
    NaN,     H13_harm(1,1),   H13_harm(2,1),   H13_harm(3,1),   NaN,       NaN,       NaN;
    Hcut,    H13_harm(1,2),   H13_harm(2,2),   H13_harm(3,2),   NaN,       NaN,       NaN;
    NaN,     NaN,              NaN,              Hm0_h,            Hm0_hand,  Hm0_M(1), Hm0_M(2);
    Tz,      NaN,              NaN,              NaN,              Tz_hand,   Tz_M(1),  Tz_M(2);
    1/Tz,    NaN,              NaN,              NaN,              fz_hand,   fz_M(1),  fz_M(2);
    NaN,     NaN,              NaN,              NaN,              Te_hand,   Te_M(1),  Te_M(2);
    NaN,     NaN,              NaN,              NaN,              fe_hand,   fe_M(1),  fe_M(2);
    NaN,     NaN,              NaN,              NaN,              Tp_hand,   Tp,       Tp;
    NaN,     NaN,              NaN,              NaN,              fp_hand,   fp,       fp;
    NaN,     NaN,              NaN,              m0_h,             m0_hand,   m0_M(1),  m0_M(2);
    NaN,     NaN,              NaN,              NaN,              mMinus1_hand,mMinus1_M(1),mMinus1_M(2);
    NaN,     NaN,              NaN,              NaN,              m2_hand,   m2_M(1),  m2_M(2)];

comparison_table = array2table(comparison_values,...
    'VariableNames',{'ZeroCrossing','Harm_Original','Harm_Demeaned',...
    'Harm_Detrended','FFT_Hand','Pwelch_Trapz','Pwelch_Sum'},...
    'RowNames',{'H1_3_m','H13_harm_m','Hcut_m','Hm0_m',...
    'Tz_s','fz_Hz','Te_s','fe_Hz','Tp_s','fp_Hz',...
    'm0_m2','mMinus1_m2s','m2_m2Hz2'});    
end