function [ MC ] = k_plex_speed_up( A )

% Input: adjacent metrix object
% Output: k-component
% Reference: S. B. Seidman and B. L. Foster, “A graph-theoretic generalization
%               of the clique concept,” Journal of Mathematical Sociology, 
%               vol. 6, pp. 139–154, 1978.

if size(A,1) ~= size(A,2)
error('MATLAB:maximalCliques', 'Adjacency matrix is not square.');
elseif any((A(:)~=1) & (A(:)~=0))
error('MATLAB:maximalCliques', 'Adjacency matrix is not boolean (zero-one valued).')
elseif any(A(:)~=reshape(A.',[],1))
error('MATLAB:maximalCliques', 'Adjacency matrix is not undirected (symmetric).')
elseif any(diag(A)~= 0)
error('MATLAB:maximalCliques', 'Adjacency matrix contains self-edges (check your diagonal).');
end

% second, set up some variables

n = size(A,2); % number of vertices
MC = cell(n,1); % storage for maximal cliques
R = false(n,1); % currently growing clique
P = true(n,1); % prospective nodes connected to all nodes in R
X = false(n,1); % nodes already processed
iclique=0;

A=A.'; %this speeds up some of the calculations below because we do not have to transpose A for each recursion

% third, run the algorithm!
BKv2(R,P,X);
MC((iclique+1):end)=[];

% version 2 of the Bron-Kerbosch algo
function [] = BKv2 ( R, P, X )

if ~any(P | X)
% report R as a maximal clique
iclique=iclique+1;
MC{iclique}=find(R);
else
% choose pivot
ppivots = P | X; % potential pivots
binP = zeros(1,n);
binP(P) = 1; % binP contains ones at indices equal to the values in P
pcounts = binP*double(A(:,ppivots)); % cardinalities of the sets of neighbors of each ppivots intersected with P
% select one of the ppivots with the largest count
[~,ind] = max(pcounts);
temp_u=find(ppivots,ind,'first');
u_p=temp_u(ind);

for u = find(~A(:,u_p) & P).' % all prospective nodes who are not neighbors of the pivot
P(u)=false;
Rnew = R;
Rnew(u)=true;
Nu = A(:,u);
Pnew = P & Nu;
Xnew = X & Nu;
BKv2(Rnew, Pnew, Xnew);
X(u)=true;
end
end

end % BKv2
end % maximalCliques