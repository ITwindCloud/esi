addpath('toolbox');
load data/msp_nuts.mat
load data/nuts_Lp.mat
nuts.Lp = Lp;

voxels = nuts.voxels; % positions of voxels
leadfield = nuts.Lp; % lead field
source_total_num = size(leadfield,2);
channel_num  = size(leadfield,1); % number of channel

for i=1:source_total_num
    leadfield(:,i) = leadfield(:,i) ./norm(leadfield(:,i));
end

[simulated,seed,clean] = get_sources(3,leadfield,voxels);

figure;
% source activity
subplot(211);plot(seed');
% scalp recording
subplot(212);plot(clean');