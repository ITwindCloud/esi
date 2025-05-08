function [svd_cor,cov_cor] = compute_svd_cov(A,B)

[sa,ua,~] = svd(A);
ta = abs(diff(diag(ua(1:size(ua),1:size(ua)))));
[~,fa] = max(ta);

[sb,ub,~] = svd(B);
tb = abs(diff(diag(ub(1:size(ub),1:size(ub)))));
[~,fb] = max(tb);


f = min(max(fa,fb),size(A,1)) + 5;
lowa = sa(:,1:f)' * A;
lowb = sb(:,1:f)' * B;

ccc = zeros(f,f);
for ic=1:f
    for jc=1:f
        ccc(ic,jc) = corr(lowa(ic,:)',lowb(jc,:)');
    end
end
svd_cor = mean(max(abs(ccc))); 
% svd_cor = abs(corr(lowa(:),lowb(:)));

cova = A' * A;
covb = B' * B;
cov_cor = corr(cova(:),covb(:));

end