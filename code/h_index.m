function h = h_index(adj)
% Calculates each nodes h-index (i.e. a node with an index h has h
% neighbours with have a degree/strength of h).
%
% Input:                   input = an undirected adjacency matrix
%
% Output:                  h = a vector containing each nodes h index

str = sum(adj);
h = zeros(1,length(str));

for i = 1:length(adj)
    % Find the neighbours of node i
    nei = str((adj(i,:) > 0));
    num_nei = length(nei);
    h_vals = zeros(1,num_nei);
    % Loops over the neighboursdisp of node i j times (where j is the number of
    % neighbours) and counts how many neighbours have at least j
    % degree/strength
    for j = 1:num_nei
        h_vals(j) = length(find(nei >= j));
    end
    % Finds the last point at which h of node i's neighbours do not have
    % less than h degree/strength. This is the nodes h-index
    temp = max(min(1:num_nei, h_vals));
%     disp(length(temp));
    if isempty(temp)
        h(i) = 0;
    else
        h(i) = temp;
    end
end
h=h';
end