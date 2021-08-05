function [Ch] = hybrid_degree(A, a, b, p)

%HYBRID_DEGREE
%          calls/requires: local.m
%          Hybrid degree centraliy metric
%          Ch = hybrid_degree(A), where A is an adjacency matrix, p is
%          spreading probability, a is normalizing factor, b is adjusting ratio,
%          computes hybrid degree centrality for each node in A
%          This metric adopts modified local centrality (Chen 12') 
%          and degree (Freeman 79') for each node.
%          (In test: a = 1; b = 5; p = 0.5;)

%          Author: Beom Woo Kang
%          Date: Jul 30, 2019

%          Reference:
%          Q. Ma and J. Ma, �Identifying and ranking influential spreaders 
%          in complex networks with consideration of spreading probability�,
%          Physica A: Statistical Mechanics and its Applications, vol.465, pp.312�330, 2017.

n = length(A);
Ch = zeros(n,1);

%compute degree
G = graph(A);
Cd = centrality(G, 'degree');

%compute modified local centrality (MLC) and hybrid degree
Cm = zeros(n,1);
Cl = semi_local(A);      %original local centrality
for v = 1:n
    sum = 0;
    Nv = find(A(v,:));
    for u = 1:length(Nv)
        sum = sum + length(find(A(Nv(u),:)));   %sum of neighbors' degree
    end
    Cm(v) = Cl(v) - 2*sum;
    Ch(v) = (b-p)*a*Cd(v) + p*Cm(v);
end