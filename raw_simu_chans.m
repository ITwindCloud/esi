scene = 'chan';
chanconfig = config.chanConfig;
savpath = 'test\chan\';
pn = size(chanconfig,1);

%%
methodn = length(methods);
metrics = zeros(pn,run,methodn,7);
trials = cell(10,1);
for i= 1:pn % parameters   
    disp(strcat('------------Parameters: ', num2str(i),'------------'));
    chanindex = chanconfig{i};
    for j = 1:run % run, 5-th run is appropriate to display in articles
        disp(strcat('~~~~~~~~~~~~~~~Run: ', num2str(j),'~~~~~~~~~~~~~~~'));
        simulated = sourceconfig{j,1};
        activity = sourceconfig{j,2};
        clean = sourceconfig{j,3};
        meg = add_raw_noise(clean,snr,noise_rest);
        noise = meg - clean;
        10 * log10(var(clean(:))/var(noise(:)))

        truesource = zeros(nv,sp);
        truesource(simulated,:) = activity;

        constrs = perform_six_methods(double(meg(chanindex,:)),normlf(chanindex,:),lf(chanindex,:));

        for m = 1:methodn % methods
            method = methods{m};
            x = constrs.(method);
            [Cor,Hit,False] = eva_Corr_Hit_False(truesource,simulated,x,nd,neighbors);
            A = (Hit-False) / 2 + 0.5;
            AP = 0.5 * (A + Hit * Cor);
            [SD,DLE] = eva_SD_and_DLE_metrics(x,simulated,voxels);
            metrics(i,j,m,:) = [A,AP,Cor,Hit,False,SD,DLE];
        end
    end
end

% save('chan-openneuro-noise.mat','metrics');
%%
