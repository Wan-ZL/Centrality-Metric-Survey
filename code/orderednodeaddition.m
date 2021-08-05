function maxclustersize = orderednodeaddition(A,orderedlist)
%A, orderedlist

n = size(A,1);
clusterlabel = zeros(n,1);
clustersizes = zeros(0,1);
clustercount = 1;
maxclustersize = zeros(n,1);

clusterlabel(orderedlist(1)) = clustercount;
clustersizes(clustercount) = 1;
clusters{1} = orderedlist(1);
maxclustersize(1) = 1;

for i=2:n
    neighbors = find(A(orderedlist(i),:));
    connections = setdiff(clusterlabel(neighbors),0);
    if isempty(connections)
        clustercount = clustercount + 1;
        clusterlabel(orderedlist(i)) = clustercount;
        clustersizes(clustercount) = 1;
        clusters{clustercount} = orderedlist(i);
    else
        [maxcluster,clusterind] = max(clustersizes(connections));
        maxclusterid = connections(clusterind);
        clusterlabel(orderedlist(i)) = maxclusterid;
        clustersizes(maxclusterid) = clustersizes(maxclusterid) + 1;
        clusters{maxclusterid} = [clusters{maxclusterid};orderedlist(i)];
        connections(clusterind) =[];
        for j=1:length(connections)
            clusterlabel(clusters{connections(j)}) = maxclusterid;
            clustersizes(maxclusterid) = clustersizes(maxclusterid) + clustersizes(connections(j));
            clustersizes(connections(j)) = 0;
            clusters{maxclusterid} = [clusters{maxclusterid};clusters{connections(j)}];
            clusters{connections(j)} = [];
        end
    end
    maxclustersize(i) = max(clustersizes);
end