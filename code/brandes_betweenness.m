function [Cb] = brandes_betweenness(A)

%BRANDES_BETWEENNESS
%          Brandes' fast betweenness centrality metric.
%          Cb = brandes_betweenness(A), where A is an adjacency matrix
%          computes the betweenness for each node in A

%          Author: Beom Woo Kang
%          Date: Jul 26, 2019

%          Reference:
%          U. Brandes, "A faster algorithm for betweenness centrality",
%          Journal of mathematical sociology, vol. 25,no. 2, pp. 163�177, 2001.

n = length(A);
Cb = zeros(n,1);

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
    
    %dependency for each node
    depn = zeros(1,n);      
    
    while ~isempty(S)
        w = S(1); S(1) = [];    %pop
        for v = 1:length(pred{w})
            depn(pred{w}(v)) = depn(pred{w}(v)) + (geod(pred{w}(v))/geod(w))*(1 + depn(w));
        end
        if w ~= s
            Cb(w) = Cb(w) + depn(w);
        end
    end
end