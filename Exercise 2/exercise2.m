% PART A : Order of a Buuterworth Filter 

passband_frequency = 5000;
passband_frequency_radians = 2*pi*passband_frequency 
passband_attenuationdB = 3; 

stopband_frequency = 15000; % in Hz
stopband_frequency_radians = 2*pi*stopband_frequency % in rad/s
stopband_attenuationdB = 40; % stopband attenuation in dB
sampling_frequency = 3*stopband_frequency; % twice the highest frequency using Nyquist theorem


[filter_order, cut_off_frequency] = buttord(passband_frequency_radians, stopband_frequency_radians, passband_attenuationdB, stopband_attenuationdB,'s')
% calculate cutoff freq to meet the passband specs
passband_cutoff_frequency = passband_spec_w_c(passband_frequency_radians,passband_attenuationdB, filter_order)


% PART B: PLOT THE FREQUENCY
% get the transfer function of the butterworth filter
[hs_num, hs_denom] = butter(filter_order, w_c, 'low', 's');
hs = tf(hs_num, hs_denom) % analog filter transfer function
% plot tthe frequency response of the analog filter
options = bodeoptions;
options.FreqUnits = 'Hz';
options.FreqScale = 'linear';
options.Xlim = [0, (sampling_frequency/2)];
options.Grid = 'on';
figure;
bode(hs, options);
title('Frequency Response of Analog Butterworth Filter');

% PART C: BILINEAR DIGITAL FILTER
% Coverting the analog filter to a digital filter using bilinear
% transformation
[hz_num, hz_denom] = bilinear(hs_num, hs_denom, sampling_frequency);
%hz = tf(hz_num, hz_denom,1/sampling_frequency);

% Get the digitl flters order
digital_filter_order = filtord(hz_num, hz_denom)

% PART D:  FREQUENCY RESPONSES
% Plotting the frequency responses of the digital filter
figure;
freqz(hz_num, hz_denom, 512, sampling_frequency);
title('FREQUENCY RESPONSE OF A DIGITAL BUTTERWORTH FILTER');

%Frequency response Comparison: Analog Vs Digital filters
% get frequency responses for the analog nd digital filters
[hz_o, wz_o] = freqs(hs_num, hs_denom, (0:(2*pi*sampling_frequency/100):(2*pi*sampling_frequency/2)));
[hz, wz] = freqz(hz_num, hz_denom, 512, sampling_frequency);

% Plot magnitude responses of both filters

figure;
plot(wz_o/(2*pi), 20*log10(abs(hz_o)), 'b', 'DisplayName', 'Analog');
hold on;
plot(wz, 20*log10(abs(hz)), 'r', 'DisplayName', 'Digital');
title('Magnitude Responses of Analog and Digital Butterworth Filters');
legend('Analog', 'Digital');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
grid on;
pbaspect([2 1 1]);
hold off;

% plot the phase responses of both filters
figure;
plot(wz_o/(2*pi), unwrap(angle(hz_o)) * 180/pi, 'r', 'DisplayName', 'Analog');
hold on;
plot(wz, unwrap(angle(hz)) * 180/pi, 'g', 'DisplayName', 'Digital');
title('PHASE RESPONSES OF ANALOG AND DIGITAL BUTTERWORTH FILTERS');
legend('Analog', 'Digital');
xlabel('Frequency (Hz)');
ylabel('Phase (degrees)');
grid on;
pbaspect([2 1 1]);
hold off;
