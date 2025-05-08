load('data\msp_nuts.mat')
% load('data\openneuro_noise_baselined.mat');
load('config-3-sources.mat')

run = 50;
snr = 5;
snr_of_trial = -15;

nd = 1;
methods = {'sloreta','mxne','lcmv','bmn','champ','sbl'};
methodn = length(methods);

covresults = struct();
covresults.des = 'parameters, runs, correlations (spatial,temporal)';

sourceconfig = config.sourceConfig;

%% chan
chanconfig = config.chanConfig;
pn = size(chanconfig,1);
covindex = zeros(pn,run,2);
for i= 1:pn % parameters   
    chanindex = chanconfig{i};
    for j = 1:run
        simulated = sourceconfig{j,1};
        activity = sourceconfig{j,2};
        clean = sourceconfig{j,3};
        [meg,~] = add_gaussian_noise(clean,snr);

        [covindex(i,j,1),covindex(i,j,2)] = compute_svd_cov(meg(chanindex,:),meg);
    end
end

covresults.chan = covindex;

covindex2 = covindex;

%% bad
badconfig = config.badConfig;
pn = length(badconfig);
covindex = ones(pn+1,run,2);
for i= 1:pn % parameters 
    bc = badconfig{i};
    for j = 1:run % run
        simulated = sourceconfig{j,1};
        activity = sourceconfig{j,2};
        clean = sourceconfig{j,3};
        [meg,~] = add_gaussian_noise(clean,snr);

        badindex = bc{j,1};
        goodindex = bc{j,2};

        % interplot
        meg2 = meg(goodindex,:);
        
        % interplot
        % meg2 = meg;
        % meg2(badindex,:) = 0;
        % meg2 = call_spheric_spline(nuts.meg.sensorCoord(:,:,1),meg2,goodindex);

        [covindex(i+1,j,1),covindex(i+1,j,2)] = compute_svd_cov(meg2,meg);

    end
end

covresults.bad = covindex;

%% region
regionconfig = config.regionConfig;
pn = length(regionconfig);
covindex = ones(pn+1,run,2);
for i= 1:pn % parameters 
    for j = 1:run % run
        simulated = sourceconfig{j,1};
        activity = sourceconfig{j,2};
        clean = sourceconfig{j,3};
        [meg,~] = add_gaussian_noise(clean,snr);

        rc = regionconfig{i};
        goodindex = rc{j,2};
        
        [covindex(i+1,j,1),covindex(i+1,j,2)] = compute_svd_cov(meg(goodindex,:),meg);
    end
end

covresults.region = covindex;

%% trial
trialconfig = config.trialConfig;
pn = length(trialconfig);
avgsnr = zeros(pn,run);
covindex = ones(pn,run,2);


for i= 1:pn-1 % parameters 
    trialnum = trialconfig(i);
    for j = 1:run
        simulated = sourceconfig{j,1};
        activity = sourceconfig{j,2};
        clean = sourceconfig{j,3};
        data = zeros(size(clean));
        for ti=1:trialnum
            [meg,~] = add_gaussian_noise(clean,snr_of_trial);
            % data = data + detrend(meg')';
            data = data + meg;
        end
        datafull = data;
        for ti=(trialnum+1):100
            [meg,~] = add_gaussian_noise(clean,snr_of_trial);
            % datafull = datafull + detrend(meg')';
            datafull = datafull + meg;
        end
        avg = data ./ trialnum;
        avgfull = datafull ./ 100;

        noise = avg - clean;
        avgsnr(i,j) = 10 * log10(var(clean(:))/var(noise(:)));

        [covindex(i,j,1),covindex(i,j,2)] = compute_svd_cov(avg,avgfull);

    end
end

covresults.trial = covindex;

%%
% save('covresults-gaussian.mat','covresults');
