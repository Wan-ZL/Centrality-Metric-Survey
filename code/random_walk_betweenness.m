function rwb = random_walk_betweenness(A)
% Random Walk Betweenness - SThis function computes Newman's random-walk betweenness 
% centrality measure.
%
% Inputs:                               A = adjacency matrix                    
%
% Output:                               b = a vector containing each nodes
%                                           random-walk betweenness 
%                                           centrality
%
% Reference:                            M.E.J. Newman, "A Measure of Betweenness Centrality 
%                                       Based on Random Walks," Social Networks, vol. 27, 
%                                       no. 1, pp. 39-54, Jan. 2005.

n = length(A);

% Create a diagonal matrix where the value D(i,i) is the degree of node i 
D = diag(sum(A,2));

% The matrix T is formed by removing the last row and column from matrix A
% and D then subtracting A from D before inversing this matrix
ind = 1:n-1;
T=inv(D(ind,ind)-A(ind,ind)+eye(n-1)*1e-3);

% The removed row and column is added back in with all values equal to zero
T(n,:) = zeros(1,n-1);
T(:,n) = zeros(n,1);

% Initialise the vector I. I(i) is sum of the current flowing through
% node i for a given source, s, and target, t
I = zeros(1,n);

neighbours = cell(n,1);

for i = 1:n
    neighbours{i} = find(A(i,:) > 0);
end

for s = 1:n-1
    for t = s+1:n
        for i = 1:n
            if i == s || i == t
                % Equation 10 in Newman, 2003
                I(i) = I(i) + 1;
            else
                j = neighbours{i};
                % Equation 9 in Newman, 2003
                I(i) = I(i) + .5*sum(A(i,j)*abs(T(i,s)-T(i,t)-T(j,s)+T(j,t)));
            end
        end
    end
end
% Equation 11 in Newman, 2003
rwb = I/(.5*n*(n-1));
rwb = transpose(rwb);
end