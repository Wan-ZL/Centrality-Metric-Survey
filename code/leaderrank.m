function Cl = leaderrank(A)

%LEADERRANK LeaderRank metric
%           Cl = leaderrank(A), where A is an adjacency matrix,
%           computes leadership score for each node in A

%           Author: Beom Woo Kang, (Performance Optimized by Zelin Wan)
%           Date: Aug 1, 2019

%           Reference:
%           L. L�, Y. Zhang, C. Yeung, and T. Zhou,  
%           �Leaders in social networks, the delicious case,
%           PLOS ONE, vol.6, no.6, pp.1�9, 06 2011.

n = length(A);
Cl = zeros(n,1);

%identify a set of survived nodes that have at least one edge connected to other node
V = zeros(1,0);     %indicate whether the node has survived or is removed
for i = 1:n
    if (isempty(find(A(i,:),1)) == 0) || (isempty(find(A(:,i),1)) == 0)
        V = [V 1];       %node i survived; has connection with ground node
    else
        V = [V 0];       %node i has been already removed
    end
end 

%add ground node that has bidirectional edges with survived nodes
A2 = [0 V; V' A];     %pad adjacency matrix

%score distribution array
S = [0 V];      %every survived node except for ground node is given 1 score

%repeat until equilibrium
for i = 1:length(A2)
    non_zero_matrix(i) = nnz(A2(i,:));
end

%first time distribution
S2 = zeros(1,n+1);
for i = 1:n+1
    Ni = find(A2(:,i));     %in-neighbors of node i
    for j = 1:length(Ni)
        kout = non_zero_matrix(Ni(j));
%         kout_old = length(find(A2(Ni(j),:)));
%         if ~isequal(kout,kout_old)
%             disp("not equal");
%         end
        S2(i) = S2(i) + 1/kout*S(Ni(j));
    end
end

%set an error boundary
keep = 0;
for i = 1:n+1
    if(S(i) - S2(i) > 0.0001)
        keep = 1;
        break;
    end
end


% non_zero_matrix = nnz(A2);
while keep
    S = S2;
    S2 = zeros(1,n+1);
    for i = 1:n+1
        Ni = find(A2(:,i));    
        for j = 1:length(Ni)
%             kout = nnz(A2(Ni(j),:));
%             disp(Ni(j));
%             disp(non_zero_matrix);
%             disp(size(A2(Ni(j),:)));
            kout = non_zero_matrix(Ni(j));
%             kout_old = length(find(A2(Ni(j),:)));
%             if ~isequal(kout,kout_old)
%                 disp("not equal");
%             end
            
            
            S2(i) = S2(i) + 1/kout*S(Ni(j));
        end
    end
    
    %set an error boundary
    keep = 0;
    for i = 1:n+1
        if(S(i) - S2(i) > 0.0001)
            keep = 1;
            break;
        end
    end
end

%final score
for i = 2:n+1
    Cl(i-1) = S(i) + V(i-1)*S(1)/n;
end
    
    
    
    