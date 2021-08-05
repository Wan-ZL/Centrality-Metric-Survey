clear; clc; clf;

data = load('data/email-Eu.mat');
G = graph(data.Problem.A, 'upper');


[bin,binsize] = conncomp(G);
idx = binsize(bin) == max(binsize);
SG = subgraph(G, idx);

centrality = [ "clusterrank" , "load_centrality", "residual_closeness", "improved_kshell", "brandes_betweenness", "l_betweenness", "communicability" , "information_centrality" , "degree" , "leaderrank" , "eccentricity" , "entropy" , "h_index" , "local", "local_betweenness" ];

y_si = zeros(1,length(centrality));
x_si = [];
y_sr = zeros(1,length(centrality));
y_random_500 = zeros(1,100);
y_random_700 = zeros(1,100);

fifty = 0.5 * numnodes(SG);
seventy = 0.7 * numnodes(SG);

for i = 1:length(centrality)
    temp500 = SG;
    temp700 = SG;
    cent = centrality(i);
    result = feval(cent, adjacency(SG));
    
    [M, I] = maxk(result, seventy);
    temp700 = rmnode(temp700, I);
    [~,binsize] = conncomp(temp700);
    n_Si = max(binsize); 
    y_si(i) = n_Si;
    
    [M, I] = maxk(result, fifty);
    temp500 = rmnode(temp500, I);
    [~,binsize] = conncomp(temp500);
    n_Si = max(binsize); 
    y_sr(i) = n_Si;
    
end

for i=1:100
    tempRandom = SG;
    x = randsample(930, fifty);
    disp(x);
    tempRandom = rmnode(tempRandom, x);
    [~,binsize] = conncomp(tempRandom);
    n_Si = max(binsize); 
    y_random_500(i) = n_Si;
    
    x = randsample(930, seventy);
    disp(x);
    tempRandom = rmnode(tempRandom, x);
    [~,binsize] = conncomp(tempRandom);
    n_Si = max(binsize); 
    y_random_700(i) = n_Si;
    
end
y_random_500 = sum(y_random_500)/length(y_random_500);
y_random_700 = sum(y_random_700)/length(y_random_700);

y_random = [y_random_500(:), y_random_700(:)];

centrality = [ "clusterrank" , "load centrality", "residual closeness", "improved kshell", "brandes betweenness", "l betweenness", "communicability" , "information centrality" , "degree" , "leaderrank" , "eccentricity" , "entropy" , "h index" , "local", "local betweenness", "random" ];

y_data = [y_sr(:), y_si(:)];
disp(y_data);
y_data = [y_data; y_random];

y_data = y_data/numnodes(SG);
p = bar(y_data);
set(gca,'xticklabel',centrality.', 'fontsize', 12);
xTick=get(gca,'xtick'); 
xMax=max(xtick); 
xMin=min(xtick); 
newXTick=linspace(xMin,xMax,15); 
set(gca,'xtick',1:15);
hold on;
xtickangle(45);
LineArray={ '-' , ':'};
Color = {'#283747', '#E67E22', '#1ABC9C'};
for k=1:2
  set(p(k),'LineStyle',LineArray{k}, 'LineWidth', 1.5, 'EdgeAlpha', 0.5, 'FaceColor', Color{k})
end
xlabel("Centrality Metrics", 'FontSize', 18, 'FontWeight', 'bold');
ylabel("Size of the Giant Component", 'FontSize', 18, 'FontWeight', 'bold');
legend('Removal of Top 50% Nodes', 'Removal of Top 70% Nodes', 'FontSize', 13);
hold off;