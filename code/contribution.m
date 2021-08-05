function   v = contribution(CIJ)
%
%   v = eigenvector_centrality_und(CIJ)
%
%   Eigenector centrality is a self-referential measure of centrality:
%   nodes have high eigenvector centrality if they connect to other nodes
%   that have high eigenvector centrality. The eigenvector centrality of
%   node i is equivalent to the ith element in the eigenvector 
%   corresponding to the largest eigenvalue of the adjacency matrix.
%
%   Inputs:     CIJ,        binary/weighted undirected adjacency matrix.
%
%   Outputs:      v,        eigenvector associated with the largest
%                           eigenvalue of the adjacency matrix CIJ.
%
%   Reference: Newman, MEJ (2002). The mathematics of networks.



n = length(CIJ);
% disp(size(CIJ));
[A, ~, ~] = edge_nei_overlap_bu(CIJ);
CIJ = A;
if sum(isnan(CIJ(:)))>1 || sum(isinf(CIJ(:)))>1
    CIJ(isnan(CIJ)) = 0;
    CIJ(isinf(CIJ)) = 0;
end
[V,D] = eig((CIJ));

[~,idx] = max(diag(D));
ec = abs(V(:,idx));
v = reshape(ec, length(ec), 1);
