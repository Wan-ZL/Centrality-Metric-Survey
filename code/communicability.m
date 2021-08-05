function Cc = communicability(A)

%COMMUNICABILITY    
%          Communicability centrality metric.
%          Cc = communicability(A), where A is an adjacency matrix,
%          computes the communicability centrality for each node in A

%          Author: Beom Woo Kang
%          Date: Jul 28, 2019

%          Reference:
%          E. Estrada and N. Hatano,
%          “Communicability in complex networks",
%          Physical Review E, vol. 77, no. 036111, 2008.

n = length(A);
Cc = zeros(n,1);
E = expm(A);

for i = 1:n
    Cc(i) = E(i,i);
end
