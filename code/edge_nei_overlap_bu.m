function [EC,ec,degij] = edge_nei_overlap_bu(CIJ)
% EDGE_NEI_OVERLAP_BU        Overlap amongst neighbors of two adjacent nodes
%
%   [EC,ec,degij] = edge_nei_bu(CIJ);
%   Entries of 'EC' that are 'inf' indicate that no
%   edge is present.  Entries of 'EC' that are 0 denote "local bridges", i.e.
%   edges that link completely non-overlapping neighborhoods.  Low values
%   of EC indicate edges that are "weak ties".
%
%   If CIJ is weighted, the weights are ignored.
%
%   Inputs:     CIJ,    undirected (binary/weighted) connection matrix
%  
%   Outputs:    EC,     edge neighborhood overlap matrix
%               ec,     edge neighborhood overlap per edge, in vector format
%               degij,  degrees of node pairs connected by each edge

[ik,jk,ck] = find(CIJ);
lel = length(ck);
N = size(CIJ,1);
[deg] = degrees_und(CIJ);
% disp(lel);
ec = zeros(1,lel);
degij = zeros(2,lel);
for e=1:lel
    neiik = setdiff(union(find(CIJ(ik(e),:)),find(CIJ(:,ik(e))')),[ik(e) jk(e)]);
    neijk = setdiff(union(find(CIJ(jk(e),:)),find(CIJ(:,jk(e))')),[ik(e) jk(e)]);
    temp = 1 - length(intersect(neiik,neijk))/length(union(neiik,neijk));
    if isinf(temp)
        ec(e) = 0;
    else
        ec(e) = temp;
    end    
    degij(:,e) = [deg(ik(e)) deg(jk(e))];
end;

ff = find(CIJ);
EC = zeros(N);
EC(ff) = ec;                        %#ok<FNDSB>
ec = ec';
% disp(EC);
