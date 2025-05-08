function [simulated,seed,clean] = get_sources(n,leadfield,voxelpos)
% Description: generate simulated sources and thier activities
% Input:
%   n: # of simulated sources
%   leadfield: the lead field matrix
%   voxelpos: postions of all voxels
% Output:
%   simulated: indexes of simulated sources
%   seed:  every row means a time course of every simulated source
%   clean: EEG or MEG generated from simulated sources without noise

sp = 500;
win = sp;
sample_time = 0.5; % sample time
tt = sample_time / sp * (1:sp); % time series

lowfreq = 1;
highfreq = 45;
lowamp = 3;
highamp = 5;

phase = 1; % phase

simulated = sort(define_source_pos(voxelpos,n,25));

hanning_signal = hanning(round(win))';
hanning_window = [zeros(1,sp - win)  hanning_signal];

seed  = zeros(n,sp);
for ii = 1:n
    freq = (highfreq-lowfreq).*rand(1) + lowfreq;
    amp = (highamp - lowamp) .* rand(1) + lowamp;
    wtmp = 2*pi*freq;
    seed(ii,:) = amp * sin(1000*tt*1e-3*wtmp + 2*pi*rand*phase).* hanning_window; % generate source time courses
    % seed(ii,:) = seed(ii,:)./sum(seed(ii,:).^2); % norm(seed(ii,:),'fro');
end

% note that this does not adjust correlations between these simulated sources here

brainactivity = zeros(size(voxelpos,1),sp);
brainactivity(simulated,:) = seed;
clean = leadfield * brainactivity;

end