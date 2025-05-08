scene = 'bad';
badconfig = config.badConfig;
savpath = 'test\bad\';
pn = length(badconfig);

%%
methodn = length(methods);
metrics = zeros(pn,run,methodn,7);
for i= 1:pn % parameters 

    disp(strcat('------------ Bad: ', num2str(i),' ------------'));
    bc = badconfig{i};

    for j = 1:run % run
        disp(strcat('~~~~~~~~~~~~~~~ Run: ', num2str(j),' ~~~~~~~~~~~~~~~'));
        simulated = sourceconfig{j,1};
        activity = sourceconfig{j,2};
        clean = sourceconfig{j,3};
        meg = add_raw_noise(clean,snr,noise_rest);
    
        truesource = zeros(nv,sp);
        truesource(simulated,:) = activity;

        badindex = bc{j,1};
        goodindex = bc{j,2};
        meg2 = meg;
        meg2(badindex,:) = 0;
        meg2 = call_spheric_spline(nuts.meg.sensorCoord(:,:,1),meg2,goodindex);

        constrs = perform_six_methods(meg2,normlf,lf);

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

save('bad.mat','metrics');