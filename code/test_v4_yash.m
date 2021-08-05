clear; clc; clf;

scale = 300;

k_size = scale;
n = scale;  %inital size of network

not_full_connect = true;
while(not_full_connect)
    A = er2(n, 0.02); %generate random graph
    G = graph(A.Adj, 'upper');
    not_full_connect = false;   % assume graph is full connect
    for i = 1:length(A.Adj)     % get fully connected graph
        if isempty(neighbors(G, i)) == true     % no neighbor(no edge)
            not_full_connect = true;   % regenerate graph
        end
    end
   
end
subplot(1,2,1);
plot(G);         %initial graph
xlabel('original network');
tic

x_k = 1:k_size;   %x-axis plotting index
y_si = zeros(1,k_size);  %y-axis plotting index 1 (for initial calculation)
y_sr = zeros(1,k_size);  %y-axis plotting index 2 (for recalculation)


%D = ct_degree(A.Adj,n);
Dc = subgraph(A.Adj);            %CHANGE
% disp(length(Dc));
D = [Dc linspace(1,n,n)'];
Dr = D;       %static array for recalculation
Dsorted = sortrows(D, 1, 'descend');  %sort by degree in descending order
   
ri = 1;     %index for where to start new iteration
r_id = zeros(1,k_size);     %result history after each recalculation
r_id(1) = Dsorted(1,2);     %save the first history

Ai = A.Adj;  %for initial calculation
Ar = A.Adj;  %for recalculation

for k = 1:k_size  %number of node removal
   
    disp(k);

    Ai(Dsorted(k,2),:) = zeros(1,n);  %remove connections between node with highest degree
    Ai(:,Dsorted(k,2)) = zeros(n,1);
    [~,binsize] = conncomp(graph(Ai));
   

    n_Si = max(binsize);    %size of giant component after k removal at once
    y_si(k) = n_Si;
   
    %for recalculation
    Ar(Dr(r_id(k),2),:) = zeros(1,n);     %use history step by step to remove nodes
    Ar(:,Dr(r_id(k),2)) = zeros(n,1);
    if ri > k
        continue;       %boundary condition
    end
   
%      Gr = graph(Ar, 'upper');
%     Dc = centrality(Gr, 'degree');       %proceed one latest recalculation
%    
    Dc = subgraph(Ar);                                                       %      CHANGE
    Dr = [Dc linspace(1,n,n)'];
    [mv,mi] = max(Dr(:,1));     %find the index of the top node
    r_id(ri+1) = mi;            %save the newest index in the history
    ri = ri + 1;                %to the next step
%    Sr = largestcomponent(Ar);
    [~,binsize] = conncomp(graph(Ar));
%    n_Sr = length(Sr);
    n_Sr = max(binsize);
    y_sr(k) = n_Sr;
end
toc

subplot(1,2,2);
plot(x_k, y_si, '--bo');
hold on;
plot(x_k, y_sr, '--rx');
xlabel('number of removed nodes');
ylabel('size of giant component');

% G1 = graph(x_k,'upper');
% subplot(1,3,3);
% plot(G1);
% xlabel('Final network');
hold off;