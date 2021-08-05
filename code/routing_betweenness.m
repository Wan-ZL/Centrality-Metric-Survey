function [RWC,H] = routing_betweenness(adj)
% INPUTS:                   adj = an N*N adjacency matrix where adj(i,j)
%                                 indicates i is the source and j is the
%                                 target
%
% OUTPUTS:                  RWC = the routing betweeness of each node
%
%                           H   = the mean first passage time of the
%                                 network. H(i,j) indicates the average
%                                 number of steps a random walker takes to
%                                 reach node j from i

% Make markov chain 
M = diag(1./sum(adj,2))*adj;

n = length(M);

% Checks if the transition matrix contains no absorbing states and is 
% irreducible
% if max(diag(M)) == 1
%     error('The transition matrix contains an absorbing state!')  
% end
% if max(isnan(M)) == 1
%     error('The transition matrix is not irreducible!')
% end
% comp = graphComponents(M);
% if sum(comp) ~= length(comp)
%     error('The transition matrix is not irreducible!')
% end

% Make identity matrix
I = eye(n);

A = M-I;

% Sets the last column of A to 1s so a unique solution can be obtained
A(:,end) = ones(n,1);

% Creates a vector of zeros apart from the last element is 1
O = zeros(1,n);
O(end) = 1;

% Find the steady state
s = O/A;

% (s(i) = S:,i))
S = repmat(s,n,1); 

Z = inv(I-M+S);

H = (repmat(diag(Z)',n,1)-Z)./S; 

RWC = n./sum(H);
RWC = RWC';