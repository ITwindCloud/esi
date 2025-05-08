scene = 'region';
regionconfig = config.regionConfig;
savpath = 'test\region\';
pn = length(regionconfig);

%%
methodn = length(methods);
metrics = zeros(pn,run,methodn,7);
disp('------------------------------------------');
disp('Region');
disp('------------------------------------------');
for i= 1:pn % parameters 

    disp(strcat('------------ Region: ', num2str(i),' ------------'));
    for j = 1:run % run
        disp(strcat('~~~~~~~~~~~~~~~ Run: ', num2str(j),' ~~~~~~~~~~~~~~~'));
        simulated = sourceconfig{j,1};
        activity = sourceconfig{j,2};
        clean = sourceconfig{j,3};
        meg = add_raw_noise(clean,snr,noise_rest);
    
        truesource = zeros(nv,sp);
        truesource(simulated,:) = activity;

        rc = regionconfig{i};
        goodindex = rc{j,2};

        constrs = perform_six_methods(double(meg(goodindex,:)),normlf(goodindex,:),lf(goodindex,:));

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

save('region.mat','metrics');