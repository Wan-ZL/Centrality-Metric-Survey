function [dp] = degree_punishment(G, k, omega)

% Input: Graph object
% Output: Degree Discound
% Reference: X. Wang, Y. Su, C. Zhao, and D. Yi, “Effective identification 
%               of mul- tiple influential spreaders by degreepunishment,” 
%               Physica A: Statistical Mechanics And Its Applications, 
%               vol. 461, pp. 238–247, 2016.

N = numnodes(G);
S = [];
dp = [];
d = [];
p = 0.5;

SS = [];
if nargin<3

    omega = 0.6;
end
for v = 1:N
    d(v) = degree(G, v);
    dp(v) = d(v);
end

for i = 1:k
    [u, idx] = max(dp);
    dp(idx) = -Inf;
    SS = [SS, u];
    S = [S, idx];
    nei = neighbors(G, idx);
    for i=1:length(nei)
        dp(nei(i)) = dp(nei(i)) - dp(idx)*omega;
        nei_nei = neighbors(G, nei(i));
        for j=1:length(nei_nei)
            dp(nei_nei(j)) = dp(nei_nei(j)) - dp(idx)*omega*omega;
        end
    end
    
end
dp = S';    