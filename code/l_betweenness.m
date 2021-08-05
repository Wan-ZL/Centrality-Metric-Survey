function [Clb] = l_betweenness(A, L)

%L_BETWEENNESS
%          L-betweenness centrality metric.
%          Clb = l_betweenness(A, L), where A is an adjacency matrix,
%          L is the longest distance of geodesic that the metric searches up to,
%          computes the l-betweenness for each node in A
%          (we use L=10 in test)

%          Author: Beom Woo Kang
%          Date: Aug 6, 2019

%          Reference:
%          M. Ercsey-Ravasz and Z. Toroczkai, 
%          �Centrality scaling in large networks�,
%          Physical review letters, vol.105, no.3, p.038701, 2010.

n = length(A);
Clb = zeros(n,1);

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
        Nv = find(A(v,:));      %neighbors of node v
        
        %for each neighbor w of node v
        for w = 1:length(Nv)
            %if w is first found
            if dist(Nv(w)) < 0
                Q = [Q Nv(w)];
                dist(Nv(w)) = dist(v) + 1;
            end

            %if v is along the path and the distance so far is less than L
            if dist(Nv(w)) == dist(v) + 1 && dist(Nv(w)) <= L
               geod(Nv(w)) = geod(Nv(w)) + geod(v);
               pred{Nv(w)} = [pred{Nv(w)} v];
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
            Clb(w) = Clb(w) + depn(w);
        end
    end
end