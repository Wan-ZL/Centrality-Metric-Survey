function [dd] = degree_discount(G, k)

% Input: Graph object
% Output: Degree Discound
% Reference: W. Chen, Y. Wang, and S. Yang, “Efficient influence maximization
%               in social networks,” pp. 199–208, 2009.

N = numnodes(G);
S = [];
dd = [];
t = [];
d = [];
p = 0.5;

SS = [];
if nargin<2
    k=10;
end
for v = 1:N
    d(v) = degree(G, v);
    dd(v) = d(v);
    t(v) = 0;
end
for i = 1:k
    [u, idx] = max(dd);
    dd(idx) = -Inf;
    SS = [SS, u];
    S = [S, idx];
    nei = neighbors(G, idx);
    for i=1:length(nei)
        if sum(ismember(nei(i), S)) == 0
            t(nei(i)) = t(nei(i))+1;
            dd(nei(i)) = d(nei(i)) - 2*t(nei(i)) - (d(nei(i)) - t(nei(i)))*t(nei(i))*p;            
        end
    end
    
end
dd = S';    