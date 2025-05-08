function power = compute_power(S,od)
% od: # of orientations 
% S : a (n x OD)-by-m matrix, where n and m mean the number of voxels and
% time points.

n = size(S,1) / od;
power = zeros(n,1);
for i=1:n
    starti = od * (i-1) + 1;
    endi = starti + (od-1);
    power(i) = mean(S(starti:endi,:) .^ 2,'all');
end

end