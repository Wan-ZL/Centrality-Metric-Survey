function Cs = subgraph(A)

%SUBGRAPH  Subgraph centrality metric.
%          Cs = subgraph(A), where A is an adjacency matrix,
%          computes the subgraph centrality for each node in A

%          Author: Beom Woo Kang
%          Date: Jul 28, 2019

%          Reference:
%          E. Estrada and J. A. Rodr�guez-Vel�zquez, 
%          �Subgraphcentrality in complex networks",
%          Physical Review E,vol. 71, no. 056103, 2005.

n = length(A);
Cs = zeros(n,1);

[evec, eval] = eig(A);
evec2 = evec.*evec;

for v = 1:n
    for j = 1:n
        u = evec2(v,j);
        e = exp(eval(j,j));
        Cs(v) = Cs(v) + u*e;
    end
end
        