function Ce = entropy(A, type)

%ENTROPY   Entropy-based metric
%          Ce = entropy(A, type), where A is an adjacency matrix, type is
%          controllable parameter whether to choose local or mapping entropy,
%          type = 1: computes local entropy
%          type = 2: computes mapping entropy
%          computes local entropy by default otherwise

%          Author: Beom Woo Kang
%          Date: Jul 30, 2019

%          Reference:
%          T. Nie, Z. Guo, K. Zhao, and Z.-M. Lu,
%          “Using mapping entropy to identify node centrality in complex networks”,
%          Physica A: Statistical Mechanics and its Applications, vol.453, pp.290–297, 2016.

if(nargin == 1)
    type = 1;
end
   
n = length(A);
Ce = zeros(n,1);

for v = 1:n
    sum = 0;
    Nv = find(A(v,:));              %neighbors of node v
    for u = 1:length(Nv)
        d = length(find(A(Nv(u),:)));      %degree of node u
        ld = log10(d);
        if type == 1
            sum = sum + d*ld;
        elseif type == 2
            sum = sum + ld;
        end
    end
    if type == 1
        Ce(v) = sum;
    elseif type == 2
        Ce(v) = length(Nv)*sum;
    end
end
