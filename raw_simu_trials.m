scene = 'trial';
trialconfig = config.trialConfig;
trialsnr = -15;
savpath = 'test\trial\';
pn = length(trialconfig);

%%
methodn = length(methods);
avgsnr = zeros(pn,run);
metrics = zeros(pn,run,methodn,7);
disp('------------------------------------------');
disp('Trial');
disp('------------------------------------------');

run_2_subn = zeros(run,1);
for i=1:run
    run_2_subn(i) = randperm(10,1);
end

for i= 1:pn % parameters 

    disp(strcat('------------Trial: ', num2str(i),'------------'));
    trialnum = trialconfig(i);

    for j = 1:run % run
        disp(strcat('~~~~~~~~~~~~~~~Run: ', num2str(j),'~~~~~~~~~~~~~~~'));
        simulated = sourceconfig{j,1};
        activity = sourceconfig{j,2};
        clean = sourceconfig{j,3};
        data = zeros(size(clean));
        for ti=1:trialnum
            meg = add_raw_noise_for_trials(clean,trialsnr,noise_rest,run_2_subn(j));
            data = data + meg;
        end
        avg = data ./ trialnum;

        noise = avg - clean;
        avgsnr(i,j) = 10 * log10(var(clean(:))/var(noise(:)));
    
        truesource = zeros(nv,sp);
        truesource(simulated,:) = activity;

        % constrs = perform_six_methods(avg,normlf,lf);
        % 
        % for m = 1:methodn % methods
        %     method = methods{m};
        %     x = constrs.(method);
        %     [Cor,Hit,False] = eva_Corr_Hit_False(truesource,simulated,double(x),nd,neighbors);
        %     A = (Hit-False) / 2 + 0.5;
        %     AP = 0.5 * (A + Hit * Cor);
        %     [SD,DLE] = eva_SD_and_DLE_metrics(x,simulated,voxels);
        %     metrics(i,j,m,:) = [A,AP,Cor,Hit,False,SD,DLE];
        % end
    end
end

% save('trial.mat','metrics');
save('avgsnr-raw.mat','avgsnr');

%%
% stat = compute_statistics_6(metrics);
% mi = 6;
% figure;
% tiledlayout(2,2);
% 
% % A
% nexttile
% st = squeeze(stat(mi,:,1,:));
% x = 1:size(metrics,1);
% errorbar(x,st(:,1),st(:,2));
% title('A');
% 
% % AP
% nexttile
% st = squeeze(stat(mi,:,2,:));
% errorbar(x,st(:,1),st(:,2));
% title('AP');
% 
% % SD
% nexttile
% st = squeeze(stat(mi,:,6,:));
% errorbar(x,st(:,1),st(:,2));
% title('SD');
% 
% % DLE
% nexttile
% st = squeeze(stat(mi,:,7,:));
% errorbar(x,st(:,1),st(:,2));
% title('DLE');
% 
% %%
% load('surf2.mat'); % surf2
% load('8surf-vol.mat'); % EC
% 
% %%
% num_neigbhors = 100;
% normcoord = surf2.coord';
% pos = coordinate_transform(voxels,normcoord);
% 
% thresh  = 0.4;
% figure;
% plot_surf(constrs.sloreta,pos,thresh,num_neigbhors,surf2,EC);
% 
% %%
% truesource = zeros(8196,500);
% truesource(sourceconfig{1,1},:) = sourceconfig{1,2};
% thresh  = 0.1;
% figure;
% plot_surf(truesource,pos,thresh,num_neigbhors,surf2,EC);
