function [activities] = source_activity_simu(n,sp,tt, alp, low_freq,high_freq,phase,efficient_win_len)
% generate source activities
%
% Input:
% N : number of source
% SP: sample point
% TT: a time series
% ALP: correlation factor
% LOW_FREQ, HIGH_FREQ: low frequence and high one
% PHASE: fixed phase
%
% Output
% ACTIVITES：a N * SP matrix
%

% 生成汉宁窗口
hanning_signal = hanning(round(efficient_win_len))';
hanning_window = [zeros(1,sp - efficient_win_len)  hanning_signal];

% hanning_window= hanning_signal;

seed  = zeros(n,sp);
for ii = 1:n
    freq = (high_freq-low_freq).*rand(1) + low_freq;
    wtmp = 2*pi*freq;
    seed(ii,:) =sin(1000*tt*1e-3*wtmp + 2*pi*rand*phase).* hanning_window; % generate source time courses
    seed(ii,:) = seed(ii,:)./sum(seed(ii,:).^2); % norm(seed(ii,:),'fro');
end

% add correlation 
beta=sqrt(1-alp^2);   % set inter corr between sources
for k=2:n
    seed(k,:) = alp*seed(1,:)+beta*seed(k,:);
end

activities = seed;

end