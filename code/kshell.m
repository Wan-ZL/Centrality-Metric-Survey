function Ck = kshell(A)

%KSHELL    K-shell decomposition metric.
%          Ck = kshell(A), where A is an adjacency matrix,
%          computes k-shell index for each node by using k-shell decomposition

%          Author: Beom Woo Kang
%          Date: Jul 28, 2019

%          Reference:
%          M. Kitsak, L. K. Gallos, S. Havlin, F. Liljeros, L. Much-nik, H. E. Stanley, and H. A. Makse,
%          �Identification of influential spreaders in complex networks",
%          Nature Physics, vol. 6, pp. 888�893, 2010.


n = length(A);
Ck = zeros(n,1);

G = graph(A);
Cd = centrality(G, 'degree');

ks = zeros(1,0);

for k = 1:n
    while 1
        %check if there is any node with degree k remaining
        stop = 1;
        for i = 1:n
            if Cd(i) <= k && Cd(i) > 0
                A(i,:) = zeros(1,n);    %prune node from graph
                A(:,i) = zeros(n,1);
                ks = [ks i];  %add node to k bucket
                stop = 0;
            end
        end
        
        %refresh centralities and continue loop
        if stop == 0
            G = graph(A);
            Cd = centrality(G, 'degree');
            continue;
        end
        
        %go on to k+1 if no node has degree k
        if stop == 1
            break;
        end
    end
    
    %assign k-shell index to the nodes in k bucket
    for i = 1:length(ks)
        Ck(ks(i)) = k;
    end
    ks = zeros(1,0);
end