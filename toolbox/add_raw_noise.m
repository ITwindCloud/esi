function y = add_raw_noise(x, snr, resting)
% ADD_RAW_NOISE add resting state noise to X signals with an SNR
%  Input:
%    X: clean signals
%    RESTING: cell, resting state noise from multiple subjects (10)
%    SNR: signal to noise ratio
%  

ln = length(resting); % # of subjects
nn =  randperm(ln,1); % select a subject
sp = size(x,2); % number of sampling point
cn = size(x,1); % number of channels

whole_noise = resting{nn} * 1e11;

% select segments as noise from whole_noise
startsp = randperm(size(whole_noise,2)-sp+1,1);
timing = startsp:(startsp+sp-1);
channels = randperm(size(whole_noise,1),cn); 
noise = whole_noise(channels, timing);

% control SNR
signalpower = var(x(:));% mean(x.^2,'all');
noisepower = var(noise(:)); % mean(noise.^2,'all');
noisevariance = signalpower / (10^(snr/10));
noise = sqrt(noisevariance / noisepower) * noise;
y = noise + x;

% 10 * log10(var(x(:))/var(noise(:)))
end

