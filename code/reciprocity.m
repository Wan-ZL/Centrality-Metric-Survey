function [reciprocity] = reciprocity(G)
% Input:  G, Diagraph G
% Output: reciprocity: Reciprocity of the graph
% Author: Yash Mahajan
% Reference: M. E. J. Newman, S. Forrest, and J. Balthrop,  
% �Emailnetworks and the spread of computer viruses,�
% PhysicalReview E, vol. 66, p. 035101, Sep. 2002

N = numnodes(G);

% For counting the number of co-links
count=0;

for i=1:N
    %successors of node i
    nei = successors(G, i);
    for j=1:length(nei)
        %successors of node j (successor of node i)
        nei_j = successors(G, nei(j));
        %checking if there exists a co-link between node i and node j
        if ismember(i, nei_j)==1
            count = count+1;
        end
    end
end

%reciprocity of the graph
reciprocity = count./numedges(G);
    


