function kc = k_component(G)

% Input: Graph object
% Output: k-component
% Reference: M. Newman, Networks: an introduction. New York, NY, USA:
%               Oxford University Press, Inc., 2010.

k=7;
A = adjacency(G);
node_num = numnodes(G);
max_flow = [];
parfor i=1:node_num
    disp(['working on: ', int2str(i)]);
    for j=1:node_num
         if i==j
             continue;
         else
             if maxflow(G, i, j)>=k
                 continue;
             else
                 A(i,j) = 0;
             end
         end
    end
end
conn = conncomp(graph(A));
kc = max(conn);
disp(kc);