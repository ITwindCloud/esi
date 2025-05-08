function [cor,hit,false] = corr_hit_false(true_sources,true_source_locs,reconstr_sources,nd)
% CORR_HIT_FASLSE computes some measures related to comparation between
% ture sources and sources reconstruted by one algorithm.
% Input Parameters:
% 1) nd = 1; % the number of directions of a source
% 2) true_sources: (N * ND) x M, n sources, nd directions, m sample pointers
% 3) true_source_locs: locations of  true sources
% 4) reconstr_sources: the same size as TRUE_SOURCES

load D:\long-matlab\low_to_high_simu\data\neighbors_8mm_60
%% find local peaks

% reconstr_sources = real(reconstr_sources);

power = sum(reconstr_sources .^ 2, 2); % the power of  every source siganl in a direction
estpower = sum(reshape(power,nd,size(power,1)/nd),1); % the sum of power of source signals in three directions
max_power = max(estpower);

[a,~] = sort(estpower,'descend');
thresh1 = a(floor(size(estpower,2) *.1)); % 10 per cent of <a>
thresh2 = max_power * 0.001;   % 1 in 1000 of <maxpower>
    
thresh = max(thresh1,thresh2);
false_thresh = thresh;
hit_thresh = thresh;

NB = 30; % 10 closest pointers

%% hit rate and correlation calculation
local_peak = find(estpower>=hit_thresh);

hit = zeros(1,size(true_source_locs,2)); % assume all sources are not found.

cor = zeros(1,size(true_sources,1)/nd); % calcutation with a true source and founded closed source

for i =1:size(true_source_locs,2)
    tsl  =  true_source_locs(i);
    % find all closest pointers of the sources <tsl> in <local_peak>
    [ab,ia,~] = intersect(local_peak,neighbors(tsl,1:NB));
    
    if ~isempty(ab) % if some closest pointers can be found
        hit(i) = 1;
        
        cor_of_closest_pointers = zeros(length(ab),1);
        for j=1:length(ab)
           est = local_peak(ia(j));
           % compute correlation of two source signals for every direction
           cor_in_every_direction = zeros(nd,1);
           for dir =1:nd
               tl = (true_source_locs(i)-1) * nd + dir;
               rl = (est-1) * nd + dir;
               source1 = true_sources(tl,:);
               source2 = reconstr_sources(rl,:);
               corrcoef_matrix = corrcoef(source1,source2);
               cor_in_every_direction(dir) = corrcoef_matrix(1,2); 
           end % for dir =1:nd

           cor_of_closest_pointers(j) = mean(cor_in_every_direction);
        end % for j=1:length(ab)
        
        ind = cor_of_closest_pointers ~= 0;
        cor(i) = max(cor_of_closest_pointers(ind));
    end % if ~empty(ab)
end


hit = sum(hit) / size(true_source_locs,2);

ind = cor ~= 0;
cor = mean(cor(ind));

if isnan(cor)
    cor =0;   
end

if isnan(hit)
    hit = 0;
end

%% false rate calculation
local_peak = find(estpower>=false_thresh);
false = ones(size(local_peak));

for i =1:size(true_source_locs,2)
    [ab,ia,~] = intersect(local_peak,neighbors(true_source_locs(i),1:NB));
    if ~isempty(ab)>0
        false(ia) = 0;        
    end
end

max_false = size(reconstr_sources,1)/ nd * 0.1 - length(true_source_locs);
false = sum(false)/max_false;

if isnan(false)
    false = 0;
end


end % function ends up
