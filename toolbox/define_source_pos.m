function [indexes_of_sources] = define_source_pos(voxels, n,threshhold)
% Find a specified number of positons of voxels. Proper distances among
% voxels are required.
%
% Input:
% VOXELS:  X * 3, positions of all voxels
% N : number of source
% THRESHHOLD: minimum of distance between any two voxels
% 
% Output
% INDEX_OF_SOURCES: 1 * N, row indexes of voxels in the VOXELS matrix
%

center = [0,0,25];
threshhold_c = 5; % the minimun of distance between the center point and any source point
voxel_n = size(voxels,1); % number of voxel

indexes = [];

for i = 1:n
    
    while true
        idx = randi([1,voxel_n],[1,1]); % randomly select a source
        
        % repeat ? 
        if ismember(idx, indexes)
            continue;
        end

        sc = voxels(idx,:);

        % distance between the center point and the source point
        dist = sqrt((sc(1)-center(1))^2 + (sc(2)-center(2))^2 + (sc(3)-center(3))^2);
        if dist < threshhold_c
            continue
        end
        
        % distances between the source point and other selected ones
        if length(indexes) < 1 % this is the first source
            indexes = [indexes idx];
            break;
        else
            v = voxels(indexes,:);
            min_dist = min(sqrt((v(1) - sc(1)).^2 + (v(2) - sc(2)).^2 + (v(3) - sc(3)).^2));
            if min_dist < threshhold
                continue;
            else
                indexes = [indexes idx];
                break
            end

        end 

    end % while true

end % for i = 1:n

indexes_of_sources = indexes;

end