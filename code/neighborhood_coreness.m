function [Cnc2] = neighborhood_coreness(A)

%NEIGHBORHOOD_CORENESS
%          Neighborhood coreness centrality metric.
%          Cnc2 = neighborhood_coreness(A), where A is an adjacency matrix,
%          computes the extended neighborhood coreness for each node
%          Cnc: original neighborhood coreness

%          Author: Beom Woo Kang
%          Date: Jul 29, 2019

%          J. Bae and S. Kim,
%          �Identifying and ranking influential spreaders in complex networks by neighborhood coreness,
%          Physica A: Statistical Mechanics and its Applications, vol. 395, pp. 549�559, 2014.

n = length(A);
Cnc = zeros(n,1);
Cnc2 = zeros(n,1);

%first compute k-shell index for each node
Ck = kshell(A);

for i = 1:n
    for j = 1:n
        %for each neighbor
        if A(i,j) == 1
            Cnc(i) = Cnc(i) + Ck(i);
        end
    end
end

for i = 1:n
    for j = 1:n
        %for each neighbor
        if A(i,j) == 1
            Cnc2(i) = Cnc2(i) + Cnc(i);
        end
    end
end

%normalize
cmax = max(Cnc2);
Cnc2 = Cnc2./cmax;
