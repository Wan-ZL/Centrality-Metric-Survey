function [Cd] = degree(A)

%DEGREE    Degree centraliy metric
%          Cd = degree(A), where A is an adjacency matrix,
%          computes degree for each node in A

%          Author: Beom Woo Kang
%          Date: Jul 22, 2019

%          Reference:
%          L. Freeman,
%          �Centrality in social networks conceptual clarification",
%          Social networks, vol. 1, pp. 215�239, 1978.

n = length(A);
Cd = zeros(n, 1);
for i = 1:n
    Cd(i) = length(find(A(i,:)));
end