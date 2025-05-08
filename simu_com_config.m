% Configurations jointly shared by four simulations (sensors, random bad
% sensor, regional bad sensors and trials

addpath('toolbox');
addpath('algorithm');
load('config-3-sources.mat'); % config
load('data\neighbors_8mm_60.mat');% neighbors
load('data\msp_nuts.mat'); % nuts
load('data\openneuro_noise_baselined.mat'); % raw noise

lf = nuts.Lp;
voxels = nuts.voxels;
nv = size(voxels,1);
sp = size(config.sourceConfig{1,2},2);
normlf = zeros(size(lf));
for i=1:size(lf,2)
    normlf(:,i) = lf(:,i) ./ sqrt(sum(lf(:,i).^2));
end

sourceconfig = config.sourceConfig;
run = 50;
snr = 5;
nd = 1;
methods = {'sloreta','mxne','lcmv','bmn','champ','sbl'};
methodn = length(methods);
fullmethods = {'sLORETA','MxNE','LCMV','BMN','Champagne','SBL-BF'};

