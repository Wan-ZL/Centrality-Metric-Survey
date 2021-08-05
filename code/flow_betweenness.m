function  [fc] = flow_betweenness(A)
%flow_betweenness        Node-wise flow betweenness
%
%   The flow coefficient is similar to betweenness centrality, but works on a local
%   neighborhood. Both incoming and outgoing connections are considered as
%   equal while calculating the flow. 
%
%   input:      A,	connection/adjacency matrix (binary, directed)
%   output:     fc,     flow betweenness for each node
%               FC,     average flow coefficient over the network
%        total_flo,     number of paths that "flow" across the central node
%
%   Reference:  Freeman L C, Borgatti S P and White D R (1991).  
%   'Centrality in valued graphs: A measure of betweenness based on network flow'.  
%   Social Networks 13, 141-154

N = size(A,1);

% initialize ...
fc        = zeros(1,N);
total_flo = fc;
max_flo   = fc;

% loop over nodes
for v=1:N
    % find neighbors - note: treats incoming and outgoing connections as equal
    [nb] = find(A(v,:) + A(:,v)');
    fc(v) = 0;
    if (~isempty(nb))
        Aflo = -A(nb,nb);
        for i=1:length(nb)
            for j=1:length(nb)
                if((A(nb(i),v))==1)&&(A(v,nb(j))==1)
                    Aflo(i,j) = Aflo(i,j) + 1;
                end
            end
        end
        total_flo(v) = sum(sum(double(Aflo==1).*~eye(length(nb))));
        max_flo(v) = length(nb)^2-length(nb);
        fc(v) = total_flo(v)/max_flo(v);
    end
end

% handle nodes that are NaNs
fc(isnan(fc)) = 0;
fc = fc';
