clc,clearvars

% Load the .mat file
data = load( "add path of your ecg signal .mat file"); 

% Extract the ECG signal
ecg_signal = data.val; 

% Sampling frequency is known
fs = 360; % Hz

%convert to new sampling frequency
fs_new = 200;
ecg_resampled = resample(ecg_signal, fs_new, fs);


% asign variables new value
fs = 200;   % Sampling frequency
ecg_signal = ecg_resampled;
t = 0:1/fs:(length(ecg_signal)-1)/fs; % Time vector

% preprocessing of ecg signal

% Ecg signal noise removal

[fs,ecg_signal] = ECG_Preprocessing(fs,ecg_signal);


% Perform FFT
N = length(ecg_signal); % Number of samples
f = (0:N-1)*(fs/N); % Frequency vector
ecg_fft = fft(ecg_signal); % Compute FFT

% Plot ECG signal in time domain and in frequency domain

% Plot original ECG signal
figure;
subplot(2,1,1);
plot(t, ecg_signal);
title('Original ECG Signal');
xlabel('Time (s)');
ylabel('Amplitude');


subplot(2,1,2);
plot(f, abs(ecg_fft)/N);
title('Magnitude Spectrum of ECG Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([0 100]); % Limit x-axis to 100 Hz for better visualization



% Time-Domain Features
% QRS Detection using findpeaks with adaptive threshold
threshold = 0.6 * max(ecg_signal); % Adaptive threshold: 60% of max amplitude
[~, R_locs] = findpeaks(ecg_signal, 'MinPeakHeight', threshold); % Detect R-peaks
R_intervals = diff(R_locs) / fs; % Calculate R-R intervals

% Calculate Heart Rate (BPM)
heart_rate = 60 ./ R_intervals;

% Frequency-Domain Features
% FFT and Power Spectrum
N = length(ecg_signal);
fft_signal = fft(ecg_signal);
amplitude_spectrum = abs(fft_signal).^2 / N; % Power spectrum

% Frequency axis
f = (0:N-1) * (fs / N);

% Spectral Entropy Calculation
normalized_spectrum = amplitude_spectrum / sum(amplitude_spectrum);
spectral_entropy = -sum(normalized_spectrum .* log2(normalized_spectrum));


% Pattern Identification
pattern = 'Unknown';
% Normal Sinus Rhythm (NSR)
if all(R_intervals > 0.6 & R_intervals < 1) && mean(heart_rate) >= 60 && mean(heart_rate) <= 100
    pattern = 'Normal Sinus Rhythm (NSR)';
end

% Atrial Fibrillation (AFib)
if any(diff(R_intervals) > 0.1) && mean(heart_rate) > 100
    pattern = 'Atrial Fibrillation (AFib)';
end

% Ventricular Tachycardia (VT)
if mean(heart_rate) > 100 && any(diff(R_intervals) < 0.2)
    pattern = 'Ventricular Tachycardia (VT)';
end

% Ventricular Fibrillation (VFib)
if spectral_entropy > 1.5
    pattern = 'Ventricular Fibrillation (VFib)';
end

% Atrial Flutter
if any(diff(R_intervals) < 0.2) && mean(heart_rate) > 100
    pattern = 'Atrial Flutter';
end

% Plotting results
figure;
subplot(3,1,1);
plot(ecg_signal);
title('Filtered ECG Signal');
xlabel('Samples');
ylabel('Amplitude');

subplot(3,1,2);
plot(R_locs, ecg_signal(R_locs), 'ro');
title('Detected R-peaks');
xlabel('Samples');
ylabel('Amplitude');

subplot(3,1,3);
plot(f, amplitude_spectrum);
title('Power Spectrum');
xlabel('Frequency (Hz)');
ylabel('Power');

% Display results
disp(['Heart Rate (BPM): ', num2str(mean(heart_rate))]);
disp(['Spectral Entropy: ', num2str(spectral_entropy)]);
disp(['Detected Pattern: ', pattern]);

% Create a report
report = struct();
report.HeartRate = mean(heart_rate);
report.SpectralEntropy = spectral_entropy;
report.Pattern = pattern;
report.RIntervals = R_intervals;
report.RPeaks = R_locs;

% Save report to a file
save('ecg_report.mat', 'report');

% Display report summary
fprintf('ECG Analysis Report:\n');
fprintf('Heart Rate (BPM): %.2f\n', report.HeartRate);
fprintf('Spectral Entropy: %.2f\n', report.SpectralEntropy);
fprintf('Detected Pattern: %s\n', report.Pattern);
fprintf('R-R Intervals (s): %s\n', num2str(report.RIntervals));
