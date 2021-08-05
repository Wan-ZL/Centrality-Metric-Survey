function Ck = katz_BW(A, a, b)

%KATZ       Katz centrality metric
%           Ck = katz(A, a, b), where A is an adjacency matrix,
%           a is a weight to consider the centralities of each node's
%           neighbors, b is extra credit given to all nodes,
%           computes katz centrality for each node in A
%           a is set 0.2 as default
%           b is set 1 as default

%           Author: Beom Woo Kang
%           Date: Aug 6, 2019

%           Reference:
%           L. Katz, �A new status index derived from sociometric analysis�,
%           Psychometrika, vol.18, no.1, pp.39�43, Mar, 1953.

if nargin == 1
    a = 0.2; b = 1;
elseif nargin == 2
    b = 1;
elseif nargin > 3 || nargin < 1
    error('invalid number of arguments');
end

A = full(double(A > 0));
n = length(A);
invmaxeig = 1/max(eig(A)); 

AT = A';

I_vec = b*ones(n,1);
I = diag(I_vec);
Ck = (inv(I - a*AT ))*I_vec;

