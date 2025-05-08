addpath('toolbox');

% global parameters
sample_rate = 1200; %sample rat
sample_time = 0.5; % sample time
sp = sample_rate * 0.5;   %sample points
source_num = 3; % number of source

efficient_win_len = sp ;

%% import previously computed data
load data/msp_nuts.mat

voxels = nuts.voxels; % positions of voxels
leadfield = nuts.Lp; % lead field
source_total_num = size(leadfield,2);
channel_num  = size(leadfield,1); % number of channel

for i=1:source_total_num
    leadfield(:,i) = leadfield(:,i) ./norm(leadfield(:,i));
end
%% source positions
source_indexes = define_source_pos(voxels,source_num,25);

% ERP
tt = sample_time / sp * (1:sp);

% source signals
low_freq = 1;
high_freq = 45;
alp = 0.5;
phase = 1;

acitivities = source_activity_simu(source_num,sp,tt, alp, low_freq,high_freq,phase,efficient_win_len);

true_source = zeros(source_total_num, sp);
for i=1:source_num
    true_source(source_indexes(i),:) = acitivities(i,:);
end

figure;
subplot(211);plot(acitivities');
subplot(212);plot(sum(true_source.^2,2));

%% save data related to true sources
save(['global-',num2str(source_num),'sources.mat'],"source_num","channel_num","efficient_win_len","voxels","leadfield","source_indexes","acitivities","true_source","noise_rest","sp",'data_type');