function Ccn = cumulative_nomination(A);

%CUMULATIVE_NOMINATION 
%           Cumulative nomination metric
%           Ccn = cumulative_nomination(A), where A is an adjacency matrix,
%           computes accumulated nomination for each node in A

%           Author: Beom Woo Kang
%           Date: Aug 2, 2019

%           Reference:
%           R. Poulin, M.-C. Boily, and B. MÃ csse,  
%           “Dynamical systems to define centrality in social networks”,
%           Social Networks, vol.22, no.3, pp.187 – 220, 2000.

n = length(A);
Ccn = zeros(n,1);

%identify a set of survived nodes that have at least one edge connected
V = zeros(1,0);     %indicate wheter the node has survived or is removed
for i = 1:n
    if (isempty(find(A(i,:),1)) == 0) || (isempty(find(A(:,i),1)) == 0)
        V = [V 1];       %node i survived; has connection with ground node
    else
        V = [V 0];       %node i has been already removed
    end
end 

%nomination score array
P = V;      %every survived node is given 1 nomination

%first time nomination
P2 = zeros(1,n);
for i = 1:n
    psum = 0;
    Ni = find(A(i,:));      %neighbors of node i
    for j = 1:length(Ni)
        psum = psum + P(Ni(j));
    end
    P2(i) = P(i) + psum;
end

%normalization
P2 = P2/sum(P2);

%set an error boundary
keep = 0;
for i = 1:n
    if(P(i) - P2(i) > 0.0001)
        keep = 1;
        break;
    end
end

%repeat until stead state
while keep
    P = P2;
    P2 = zeros(1,n);
    for i = 1:n
        psum = 0;
        Ni = find(A(i,:));     
        for j = 1:length(Ni)
            psum = psum + P(Ni(j));
        end
        P2(i) = P(i) + psum;
    end
    P2 = P2/sum(P2);
    
    %set an error boundary
    keep = 0;
    for i = 1:n
        if(P(i) - P2(i) > 0.0001)
            keep = 1;
            break;
        end
    end
end

%final nomination score
Ccn = P';







