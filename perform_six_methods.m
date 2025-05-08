function constrs = perform_six_methods(meg,lf,lf2)
% lf is a normalized lead field while lf2 is a raw lead field.

constrs = struct();

tic
iter_num = 100;
plot_on = 0;
[~,constrs.champ,~,c,~,sigu] = champagne(meg,lf,iter_num,1,0,plot_on,2,0);
disp(strcat('Champagne: ',num2str(toc)));


% SBL-BF
tic
[weight,~, ~]= sbl_bf(lf,c / norm(c),0);
weight = permute(weight,[1 3 2]);
w = reshape(weight,size(weight,1),size(weight,2)*size(weight,3));
constrs.sbl = w'*meg;
disp(strcat('SBL-BF: ',num2str(toc)));

% BMN
tic
[~,constrs.bmn,~,~,~,~] = bmn(meg,lf,sigu,iter_num,'wi',1);
disp(strcat('BMN: ',num2str(toc)));

% sLORETA
tic
nd = 1;
[nc,nov] = size(lf);
LF1 = reshape(lf,nc,nd,nov);
ddd.Ryy = meg * meg'./size(meg,2);
[weight]= sLORETA(double(LF1),ddd);
w = reshape(weight,size(weight,1),size(weight,2)*size(weight,3));
constrs.sloreta = real(w' * meg);
disp(strcat('sLORETA: ',num2str(toc)));

% LCMV
tic
% Ryy = cov(meg'); % Ryy [271,271],Ryy 是样本协方差矩阵
% gamma = 1e0*max(eig(Ryy));
% covariance  = Ryy+gamma*eye(size(Ryy));
% alpha = 0;
% [weight,~, ~] = lcmv(lf,covariance,0);   

sp = size(meg,2);
Sample_covariance = meg*meg'./sp;
Sample_covariance = Sample_covariance./norm(Sample_covariance);
[weight,~, ~] = lcmv(lf,Sample_covariance);


weight = permute(weight,[1 3 2]); 
w = reshape(weight,size(weight,1),size(weight,2) * size(weight,3));
constrs.lcmv = real(w'*meg);
disp(strcat('LCMV: ',num2str(toc)));

% MxNE
tic
plot_on = 0;
[mx,~] = ccai(meg,lf2,sigu,100,nd,plot_on);
disp(strcat('MxNE: ',num2str(toc)));
constrs.mxne = real(mx);

end