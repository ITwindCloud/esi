function badidx = get_regional_bad_channels(share,x,y,angle)
% Description: return indexes of sensors located in a sector region, which
%              is defined with the starting ANGLE and the occupied SHARE of a whole circle.
% total = 8; % the number of shares in total

a = angle / 360 * 2 * pi;
tmpx = x;
tmpy = y;
x = tmpx * cos(a) - tmpy * sin(a);
y = tmpx * sin(a) + tmpy * cos(a);

if share == 1
    badidx = find(x >= 0 & y <= x & y >=0);
elseif share == 2
    badidx = find(x >= 0 & y >= 0);
elseif share == 3
    badidx = find((x <=0 & y >= -1 * x) | (x >= 0 & y >= 0));
elseif share == 4
    badidx = find(y >= 0);
elseif share == 5
    badidx = find((x <=0 & y >= x) | (x >= 0 & y >= 0));
elseif share == 6
    badidx = find(x <= 0 | (x >= 0 & y >= 0));
elseif share == 7
    badidx = find(x <= 0 | (x >= 0 & y >= 0) | (x >= 0 & y <= -1 * x));
elseif share == 8
    badidx = 1:numel(x);
else
    disp('There are only 8 shares in total!!');
end



end


%%
% x = 1:0.1:100;
% y = x * 0.2 + 1;
% y2 = y + randn(1,numel(x)) * 20;
% figure;
% scatter(x,y2);
% 
% [b,bint,r,rint,stats] = regress(y2',[ones(numel(x),1),x']);