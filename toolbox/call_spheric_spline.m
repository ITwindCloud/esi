
function  channeldatanew = call_spheric_spline(sensors_coords,data,goodchans)

[nc nt] = size(data);

badchans = setdiff(1:nc,goodchans);

xelec = sensors_coords(goodchans,1);
yelec = sensors_coords(goodchans,2);
zelec = sensors_coords(goodchans,3);

rad = sqrt(xelec.^2+yelec.^2+zelec.^2);
xelec = xelec./rad;
yelec = yelec./rad;
zelec = zelec./rad;

xbad = sensors_coords(badchans,1);
ybad = sensors_coords(badchans,2);
zbad = sensors_coords(badchans,3);

rad = sqrt(xbad.^2+ybad.^2+zbad.^2);
xbad = xbad./rad;
ybad = ybad./rad;
zbad = zbad./rad;


[tmp1 tmp2 tmp3 badchansdata] = spheric_spline( xelec', yelec', zelec', xbad', ybad', zbad', data(goodchans,:));


channeldatanew = data;
channeldatanew(badchans,:) = badchansdata;


end


function [xbad, ybad, zbad, allres] = spheric_spline( xelec, yelec, zelec, xbad, ybad, zbad, values);

newchans = length(xbad);
numpoints = size(values,2);

% SPHERERES = 20;
% [x,y,z] = sphere(SPHERERES);
% x(1:(length(x)-1)/2,:) = []; xbad = [ x(:)'];
% y(1:(length(x)-1)/2,:) = []; ybad = [ y(:)'];
% z(1:(length(x)-1)/2,:) = []; zbad = [ z(:)'];

Gelec = computeg(xelec,yelec,zelec,xelec,yelec,zelec);
Gsph  = computeg(xbad,ybad,zbad,xelec,yelec,zelec);

% compute solution for parameters C
% ---------------------------------
meanvalues = mean(values);
values = values - repmat(meanvalues, [size(values,1) 1]); % make mean zero

values = [values;zeros(1,numpoints)];
C = pinv([Gelec;ones(1,length(Gelec))]) * values;
clear values;
allres = zeros(newchans, numpoints);

% apply results
% -------------
for j = 1:size(Gsph,1)
    allres(j,:) = sum(C .* repmat(Gsph(j,:)', [1 size(C,2)]));
end
allres = allres + repmat(meanvalues, [size(allres,1) 1]);
end




% compute G function
% ------------------
function g = computeg(x,y,z,xelec,yelec,zelec)

unitmat = ones(length(x(:)),length(xelec));
EI = unitmat - sqrt((repmat(x(:),1,length(xelec)) - repmat(xelec,length(x(:)),1)).^2 +...
    (repmat(y(:),1,length(xelec)) - repmat(yelec,length(x(:)),1)).^2 +...
    (repmat(z(:),1,length(xelec)) - repmat(zelec,length(x(:)),1)).^2);

g = zeros(length(x(:)),length(xelec));
%dsafds
m = 4; % 3 is linear, 4 is best according to Perrin's curve
ismatlab = 1; % temporary for normal work of codes
for n = 1:7
    if ismatlab
        L = legendre(n,EI);
    else % Octave legendre function cannot process 2-D matrices
        for icol = 1:size(EI,2)
            tmpL = legendre(n,EI(:,icol));
            if icol == 1, L = zeros([ size(tmpL) size(EI,2)]); end
            L(:,:,icol) = tmpL;
        end
    end
    g = g + ((2*n+1) /(n^m*(n+1)^m))*squeeze(L(1,:,:));
end
g = g/(4*pi);
end