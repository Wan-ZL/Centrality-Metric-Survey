function Ccr = clusterrank(A)

%CLUSTERRANK ClusterRank metric
%           calls/requires: clustering_coef_wd.m
%           Ccr = clusterrank(A), where A is an adjacency matrix,
%           computes clusterrank value for each node in A

%           Author: Beom Woo Kang
%           Date: Aug 2, 2019

%           Reference:
%           D.-B. Chen, H. Gao, L. LÃij, and T. Zhou, 
%           “Identifying influential nodes in large-scale directed networks: The role of clustering”,
%           PLOS ONE, vol.8, no.10, pp.1–10, 10 2013.

n = length(A);
Ccr = zeros(n,1);

%compute local clustering coefficient for each node
Cc = clustering_coef_wd(A);

for i = 1:n
    sum = 0;
    Ni = find(A(i,:));      %set of neighbors of node i
    for j = 1:length(Ni)
        kj = length(find(A(Ni(j),:)));  %out-degree of node j
        sum = sum + kj + 1;
    end
    f = 10^(-Cc(i));        %defined function f(c_i) = 10^(-c_i)
    Ccr(i) = f*sum;
end
    