function [sd,dle] = eva_SD_and_DLE_metrics(S,simulated,voxelpos) 
% S: estimated source time courses (voxels X times)
% simulated: indexes of simulated sources
% vexolpos : postions of all voxels

power = compute_power(S,1); % compute power of each voxel with one direction
tp = size(S,2);
powerthresh = 0.05 * max(power); % 0.01 for champagne, 0.1 for sloreta, 0.001 for lcmv
% powerthresh = 0;

n = numel(simulated);
simpos = voxelpos(simulated,:);
corrsp = dsearchn(simpos,voxelpos);

numerator = 0;
denominator = 0;
for i=1:n
    idx = find(corrsp == i & power >= powerthresh);
    for j=1:numel(idx)
        d = sum((voxelpos(idx(j),:) - voxelpos(simulated(i),:)) .^ 2);
        numerator = numerator + d * power(idx(j)) * tp;
        denominator = power(idx(j)) * tp;
    end
end

% SD
sd = sqrt(numerator / denominator);

distance = 0;
K = 0;
for i=1:n
    idx = find(corrsp == i);
    if numel(idx) <= 0
        continue;
    end
    K = K + 1;
    tmppower = power(idx,:);
    [~,tmpi] = max(tmppower);
    distance = distance + sqrt(sum((voxelpos(idx(tmpi),:) - voxelpos(simulated(i),:)) .^ 2));
end

% DLE
dle = distance / K;

end