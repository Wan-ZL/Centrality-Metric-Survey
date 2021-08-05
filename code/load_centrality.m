function [Cl] = load_centrality(A)

%Load Centrality
%          Author: Yash Mahajan
%          Reference:
%          U. Brandes, "On Variants of Shortest-Path Betweenness
%          Centrality and their Generic Computation"
%

n = length(A);
Cl = zeros(n,1);

for s = 1:n
    %initialize stack
    S = zeros(1,0);
    
    %predecessors for each node
    pred = cell(n,1); 
    
    %number of geodesics from node s
    geod = zeros(1,n); geod(s) = 1;    
    
    %distance of geodesic from node s
    dist = zeros(1,n); dist(1:n) = -1; dist(s) = 0;
    
    %initialize queue; enqueue source node
    Q = zeros(1,0); Q = [Q s];
    
    while ~isempty(Q)
        v = Q(1); Q(1) = [];    %dequeue
        S = [v S];              %push
        
        for w = 1:n
            %for each neighbor w of node v
            if A(v,w) == 1
                %if w is first found
                if dist(w) < 0
                    Q = [Q w];
                    dist(w) = dist(v) + 1;
                end
                
                %if v is among the path
                if dist(w) == dist(v) + 1
                   geod(w) = geod(w) + geod(v);
                   pred{w} = [pred{w} v];
                end
            end
        end
    end
    
    %accummulate
    
    %dependency for each node
    depn = ones(1,n);      
    
    while ~isempty(S)
        w = S(1); S(1) = [];    %pop
        for v = 1:length(pred{w})
            depn(pred{w}(v)) = depn(pred{w}(v)) + (depn(w)/(length(pred{w})));
        end
        %load centrality Cl
        Cl(w) = Cl(w) + depn(w);
    end
end
