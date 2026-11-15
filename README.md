# Wave Analysis in MATLAB

Educational MATLAB workflow for exploring ocean-wave time series in both the **time and frequency domains**, from individual zero-crossing waves to Fourier harmonics, wave spectra and directional spectral parameters.

The code was developed primarily as a teaching tool. Its objective is to make the calculations visible and understandable rather than hiding the processing behind high-level functions. Where useful, calculations performed directly from the equations are compared with equivalent MATLAB functions.

## Repository structure

```text
.
├── main_wave.m
├── wave_figures.m
├── obtain_the_comparative_table.m
├── WaveData/
│   ├── example_directional_buoy_standard.txt
│   └── example_directional_buoy_realistic.txt
└── .gitignore
```

### `main_wave.m`

Main script containing the successive analyses. It covers:

- loading synchronized vertical, North and West motion time series;
- Cartesian, mathematical and oceanographic directional conventions;
- basic elevation statistics;
- zero-upcrossing identification of individual waves;
- individual wave height \(H\), zero-crossing period \(T_z\), and \(H_{1/3}\);
- demeaning and linear detrending;
- FFT decomposition into amplitude, frequency and phase;
- comparison between original, demeaned and detrended Fourier harmonics;
- direct calculation of the one-sided wave spectrum from the FFT;
- spectral moments \(m_{-1}\), \(m_0\) and \(m_2\);
- spectral parameters \(H_{m0}\), \(T_e\), \(T_z\), \(T_p\) and their associated frequencies;
- comparison between spectra calculated directly from the equations and with MATLAB functions;
- JONSWAP and Bretschneider reference spectra;
- directional spectral analysis from vertical, North and West motions;
- directional Fourier coefficients and directional wave parameters.

### `wave_figures.m`

Contains the figures associated with the different stages of `main_wave.m`.

The figures are separated from the calculations so that the main script remains focused on the mathematical and physical processing.

### `obtain_the_comparative_table.m`

Creates a final comparison table gathering wave parameters obtained through the different approaches, including:

- zero-crossing analysis;
- Fourier-harmonic analysis;
- direct FFT spectrum;
- Welch spectrum calculated from the equations;
- MATLAB `pwelch` calculations.

Some intentionally experimental quantities, such as the highest-third harmonic height, are retained only to illustrate why Fourier harmonic amplitudes should not be interpreted as individual physical wave heights.

### `WaveData/`

Contains two example directional-buoy-like time series.

The principal variables used by the scripts are:

```text
time_s        time [s]
elevation_m   vertical free-surface elevation / heave [m]
north_m       North-positive horizontal displacement [m]
west_m        West-positive horizontal displacement [m]
```

## Running the analysis

Open MATLAB in the repository root and run:

```matlab
main_wave
```

The input dataset can be selected near the beginning of `main_wave.m`:

```matlab
option_version=1;   % standard example
```

or

```matlab
option_version=2;   % more irregular/realistic example
```

Individual figures can be enabled or disabled through:

```matlab
option_plot_figure=[...
    1,... % Raw directional buoy motion
    1,... % Cartesian/directional illustration
    1,... % Direction-convention transformations
    1,... % Elevation statistics
    1,... % Zero-crossing analysis
    1,... % Harmonic analysis
    1,... % Spectrum/harmonics/elevation comparison
    1,... % Directional spectrum
]';
```

Set an entry to `0` to skip the corresponding figure.

An additional option activates some intermediate calculations intended mainly for users interested in reproducing MATLAB's spectral processing manually:

```matlab
option_for_the_curious=1;
```

## Main concepts illustrated

### Zero-crossing waves

Individual waves are identified between consecutive upward crossings of the mean water level.

The exact crossing time between two sampled elevations is estimated by linear interpolation. Individual crest-to-trough heights and crossing-to-crossing periods are then obtained, allowing the classical time-domain significant wave height

\[
H_{1/3}
\]

to be calculated from the mean of the highest one-third of observed wave heights.

### Fourier harmonics

The discrete Fourier transform decomposes the elevation into sinusoidal components characterised by:

\[
a_k,\qquad f_k,\qquad \phi_k
\]

such that an ordinary one-sided harmonic can be represented by

\[
a_k\cos(2\pi f_k t+\phi_k).
\]

The code explicitly explores:

- positive and negative frequencies;
- complex-conjugate symmetry;
- DC and Nyquist components;
- FFT normalisation;
- phase;
- the effect of demeaning and detrending.

### Frequency spectrum

The one-sided spectral density is also calculated directly from the FFT and compared with MATLAB's Welch implementation.

For an ordinary Fourier harmonic,

\[
\frac{a_k^2}{2}\approx S(f_k)\Delta f.
\]

The spectrum is then used to calculate the spectral moments

\[
m_n=\int f^nS(f)\,df
\]

and associated wave parameters such as

\[
H_{m0}=4\sqrt{m_0},
\]

\[
T_e=\frac{m_{-1}}{m_0},
\]

and

\[
T_z=\sqrt{\frac{m_0}{m_2}}.
\]

### Directional spectrum

Directional information is obtained from the synchronized vertical, North and West motions rather than from an instantaneous direction value alone.

Auto- and cross-spectra are used to calculate directional Fourier coefficients \(a_1\), \(b_1\), \(a_2\) and \(b_2\), from which the directional distribution and directional frequency spectrum can be reconstructed.

The analysis includes the peak wave direction \(\theta_p\) and mean wave direction \(\theta_m\), using an oceanographic direction convention.

## MATLAB requirements

The workflow requires MATLAB.

The spectral processing uses functions from the **Signal Processing Toolbox**, particularly:

```matlab
pwelch
cpsd
hann
```

## Purpose and limitations

This repository is intended for **teaching, experimentation and understanding the mathematics behind wave analysis**.

It deliberately contains direct calculations alongside MATLAB functions so that intermediate quantities remain visible and can be compared.

It is not intended to be a complete operational directional-buoy processing package. For real observational applications, additional considerations may be required, including instrument response corrections, quality control, sensor calibration, magnetic declination, water-depth effects and instrument-specific processing conventions.

The example calculations should therefore be interpreted as pedagogical implementations of the underlying concepts rather than as a substitute for the processing standards supplied with a particular wave-measurement system.

## Licence

No licence is currently included in this repository.