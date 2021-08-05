function Cl = semi_local_old(A)

%LOCAL     Local centraliy metric
%          Cl = local(A), where A is an adjacency matrix,
%          computes local centrality for each node in A

%          Author: Beom Woo Kang
%          Date: Jul 30, 2019

%          Reference:
%          D. Chen, L. L�, M.-S. Shang, Y.-C. Zhang, and T. Zhou,
%          �Identifying influential nodes in complex networks�,
%          Physica A: Statistical mechanics and its applications, vol.391, no.4, pp.1777�1787, 2012.

n = length(A);
Cl = zeros(n,1);

G = graph(A);
D = distances(G);

parfor v = 1:n
    Nv = find(A(v,:));              %neighbors of node v
    Qv = zeros(1,length(Nv));
    for u = 1:length(Nv)        
        Nu = find(A(Nv(u),:));          %neighbors of node u
        for w = 1:length(Nu)
            Qv(u) = Qv(u) + length(find(D(Nu(w),:) == 2));
        end     
    end
    Cl(v) = sum(Qv);
end