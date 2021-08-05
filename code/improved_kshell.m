function [Ci] = improved_kshell(A)

%IMPROVED_KSHELL
%          Improved version of k-shell decomposition metric.
%          Ci = improved_kshell(A), where A is an adjacency matrix,
%          computes k-shell index for each node by using k-shell decomposition,
%          further ranks nodes that have the same k-shell index to distinguish
%          This metric returns the ranking point of each node by giving
%          extra points based upon rank on top of K-shell index

%          Author: Beom Woo Kang
%          Date: Jul 29, 2019

%          Reference:
%          J. -G. Liu, Z. -M. Ren, and Q. Guo,
%          “Ranking thespreading influence in complex networks",
%          Physica A: Statistical Mechanics and its Applications, vol.392, no.18, pp.4154–4159, 2013.

n = length(A);
Ci = zeros(n,1);

%first compute k-shell index for each node
Ck = kshell(A);

%list of existing k-shell indices in descending order
K = sort(unique(Ck), 'descend');
kmax = K(1);                  %largest k-shell index

%sets of nodes that have from 1 to k of k-shell index
kset = cell(length(K), 1);
ksize = zeros(1,length(K));
for i = 1:length(K)
    tmp = Ck == K(i);         %indices of nodes that have K(i) score
    kset{i} = find(tmp);
    ksize(i) = length(kset{i});
end
%core nodes
core = kset{1};

%compute geodesics
G = graph(A);
D = distances(G);

%ranking process
for i = 1:length(K)
    tmpval = zeros(ksize(i),2);    %temporary container to store \theta
    tmpval(:,2) = kset{i}';
    for j = 1:ksize(i)
        %compute sum of geodesics between network core nodes
        dsum = 0;
        for k = 1:ksize(1)            %number of core nodes
            dsum = dsum + D(kset{i}(j),kset{1}(k));
        end
        tmpval(j,1) = (kmax - K(i) + 1)*dsum;
    end
    rank = sortrows(tmpval, 1, 'ascend');   %rank nodes based on \theta
    
    %extra point based on rank
    point = 1/(ksize(i) + 1);   %one unit of point; +1 to avoid boundary overlapping
    for j = 1:ksize(i)
        recipient = rank(j,2);
        Ci(recipient) = K(i) + (ksize(i) - j)*point;
    end
end

%normalize result
cmax = max(Ci);
Ci = Ci./cmax;
