function [Cm] = mixed_degree_decomposition(A, lambda)

%MIXED_DEGREE_DECOMPOSITION     
%          Mixed degree decomposition metric.
%          Cm = subgraph(A, lambda), where A is an adjacency matrix, 
%          lambda is a controllable parameter between 0 and 1,
%          computes the subgraph centrality for each node in A
%          lambda = 0 : normal k-shell decomposition
%          lambda = 1 : degree centrality metric

%          Author: Beom Woo Kang
%          Date: Jul 28, 2019

%          Reference:
%          A. Zeng and C. -J. Zhang,
%          “Ranking spreaders by decomposing complex networks",
%          Physics Letters A, vol.377, no. 14, pp. 1031–1035, 2013.

if nargin<2
    lambda = 0.5;   
end

n = length(A);
Cm = zeros(n,1);

%end function if graph is empty
if A == zeros(n,n)
    return
end

%k_m values at initial step which equal to degrees
G = graph(A);
km = centrality(G, 'degree');

%substitue 0 to Infinity to match format
infi = ismember(km, 0);
km(infi) = Inf;

mshell = zeros(1,0); 
M = zeros(1,n);     %M values of which the number is n at maximum

%to check if all nodes are assigned M-shell index
remains = linspace(1,n,n);

for k = 1:n
    %find the smallest k_m value
    mval = min(km);
    M(k) = mval;
    while 1
        stop = 1;
        
        %prune nodes that have smallest k_m value
        for i = 1:n
            if km(i) <= mval && km(i) > 0
                A(i,:) = 0;    %make pruned edges as 0
                A(:,i) = 0;
                mshell = [mshell i];    %add node to M-shell
                remains(i) = 0;
                km(i) = Inf;
                stop = 0;
            end
        end
        
        %refresh k_m values and continue loop
        if stop == 0
            kr = zeros(1,n);
            ke = zeros(1,n);
            %compute k_r, k_e for each node by counting edge value 1,0 respectively
            for i = 1:n
                %compute k_m if node remains in graph
                if remains(i) ~= 0
                    sum_kr = 0;
                    sum_ke = 0;
                    for j = 1:n
                        if A(i,j) == 1
                            sum_kr = sum_kr + 1;
                        elseif A(i,j) == 0
                            sum_ke = sum_ke + 1;
                        end
                    end
                    kr(i) = sum_kr;
                    ke(i) = sum_ke;
                    %compute k_m based on k_r, k_e
                    km(i) = kr(i) + lambda*ke(i);
                end
            end
        end 
        
        %go on to next M value
        if stop == 1
            break;
        end
    end
    
    %assign M-shell index to nodes in M-shell
    for i = 1:length(mshell)
        Cm(mshell(i)) = M(k);
    end
    mshell = zeros(1,0);
    
    %break loop if all nodes are assigned its M-shell index
    if remains == zeros(1,n)
        break;
    end
end
                
                
                
                
                