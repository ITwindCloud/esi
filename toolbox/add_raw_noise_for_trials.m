function y = add_raw_noise_for_trials(x, snr, resting, subn)
% ADD_RAW_NOISE add resting state noise to X signals with an SNR
%  Input:
%    X: clean signals
%    RESTING: cell, resting state noise from multiple subjects (10)
%    SNR: signal to noise ratio
%    SUBN: number of the chosen subject
%  

% ln = length(resting); % # of subjects
nn =  subn; % select a subject
sp = size(x,2); % number of sampling point
cn = size(x,1); % number of channels

whole_noise = resting{nn};

% select segments as noise from whole_noise
startsp = randperm(size(whole_noise,2)-sp+1,1);
timing = startsp:(startsp+sp-1);
channels = randperm(size(whole_noise,1),cn); 
noise = whole_noise(channels, timing);

% control SNR
signalpower = var(x(:));
noisepower = var(noise(:));
noisevariance = signalpower / (10^(snr/10));
noise = sqrt(noisevariance / noisepower) * noise;
y = noise + x;
end

