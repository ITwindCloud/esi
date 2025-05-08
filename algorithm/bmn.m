
% latest version including sigu update, unverified
% make plot of like vs v for given sigu

function [v,x,w,like,sigu0,c]=cai_bmn(y,f,sigu,nem,vupd,nupd);

% vupd='em','wi'
% nupd=0,1

eps1=1e-8;
eps1z=1e-8;
[nk, nvd]=size(f);
nt=size(y,2);

cyy=y*y'/nt;

% Initialize voxel variances

f2=sum(f.^2,1);
invf2=zeros(1,nvd);
ff=find(f2>0);
invf2(ff)=1./f2(ff);
w=spdiags(invf2',0,nvd,nvd)*f';
v0=mean(mean((w*y).^2));

sigy=mean(mean(y.^2));
sigf=sum(sum(f.^2))/nk;
sigu0=mean(diag(sigu));
v1=max((sigy-sigu0)/sigf,eps1);

v=v0;

reg=sigu0/v;
% disp(['initial: v = ' num2str(v) '   n = ' num2str(sigu0)]);
% disp(['reg = ' num2str(reg)]);
% disp(['use ' vupd ' update']);

% Learn voxel variance

% figure;

like=zeros(nem,1);
vv=zeros(nem,1);
nn=zeros(nem,1);
ilam=sigu0;

for iem=1:nem
    c=v*f*f'+sigu;
    [p d]=svd(double(c));
    d=max(real(diag(d)),0);
    invd=zeros(nk,1);
    ff=find(d>=eps1);
    invd(ff)=1./d(ff);
    invc=p*spdiags(invd,0,nk,nk)*p';
    
%    like(iem)=-.5*(sum(log(d))+nk*log(2*pi))-.5*sum(sum(y.*(invc*y)))/nt; 
%     like(iem)=-.5*(sum(log(max(d,eps1)))+nk*log(2*pi))-.5*sum(sum(invc.*cyy));    
%     subplot(2,2,2);plot((1:iem),like(1:iem));
%     title(['Likelihood: ' int2str(iem) ' / ' int2str(nem)]);
%     xlabel('iteration');
%     set(gca(),'XLim',[0 iem]);
    
    fc=f'*invc;
    w=v*fc;
    x2=sum((w*cyy).*w,2);
    z=sum(fc.*f',2);

    if vupd=='wi'
        x20=sum(x2);
        z0=sum(z);
        v=(sqrt(z0)/max(z0,eps1z))*sqrt(x20);
    elseif vupd=='em'
        igam=v*ones(nvd,1)-sum(w.*f',2)*v;
        v=mean(x2+igam);
    else
        disp([vupd ' ??']);
    end
    
% sigu update -- verify! 
% also change mean(mean(y1.^2)) --> mean(diag((i-fw)cyy(i-fw)')
% and verify that too
    if nupd==1
%        y1=y-f*w*y;
%        sigy1=mean(mean(y1.^2));
        fw=eye(nk)-f*w;
        sigy1=mean(sum((fw*cyy).*fw,2));
        fgf=v*sum((fw*f).*f,2);
        ilam=sigy1+mean(fgf);
        sigu=ilam*eye(nk);
    end

%     vv(iem)=v;
%     subplot(2,2,1);plot((1:iem),vv(1:iem));
%     title(['Voxel variance: ']);
%     xlabel('iteration');
%     set(gca(),'XLim',[0 iem]);
%     
%     nn(iem)=ilam;
%     subplot(2,2,3);plot((1:iem),nn(1:iem));
%     title(['Noise power: ']);
%     xlabel('iteration');
%     set(gca(),'XLim',[0 iem]);
%     
%     subplot(2,2,4);plot((1:nvd),x2);
%     title('Voxel power');
%     axis([1 nvd 0 1.1*max(x2)]);
%     drawnow
end
   
x=w*y;
c=v*f*f'+sigu;
sigu0=mean(diag(sigu));
reg=sigu0/v;
% disp(['final: v = ' num2str(v) '   n = ' num2str(sigu0)]);
% disp(['reg = ' num2str(reg)]);

return

