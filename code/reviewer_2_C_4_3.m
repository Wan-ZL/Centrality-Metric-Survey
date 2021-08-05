clear; clc; clf;

% CHANGE parameter here
% node_scale = 1895; % the length of array in file (4039 for facebook) (1895 for CollegeMsg)

% ==================== below is new group ====================
% (show separately for local, iterative, and global Point Centrality metrics)
% Local: 
% metric_name = ["random","degree","semi_local","hybrid_degree","volume","clustering_coef"];  % no data: Curvature
% metric_name = ["random", "redundancy","local_entropy","mapping_entropy","h_index"];
% metric_name = ["random", "clusterrank"];
% Iterative:
% metric_name = ["random","kshell","mixed_degree_decomposition","neighborhood_coreness","eigenvector","katz","pagerank"];
% metric_name = ["random","contribution","diffusion_centrality","subgraph","dynamic_influence","cumulative_nomination"];
metric_name = ["random","hubs","authorities","leaderrank","SALSA_authorities","SALSA_hubs"];
% Global:
% metric_name = ["random","improved_kshell","betweenness","flow_betweenness","closeness","information_centrality","residual_closeness"];
% metric_name = ["random","GDSP_degree","GDSP_closeness","GDSP_betweenness","weight_neighborhood","percolation","eccentricity"];
% no data: metric_name = ["random","l_betweenness","random_walk_betweenness","loadcentrality","routing_betweenness"]; % Current-flow, Spatial, AHP

marker_shape = ["-ko", "-p", "-*", "-^", "-+", "-.", "-x", "-s", "-v", "-d", "->", "-<", "-h"];
plot_size = 2.5;
font_size = 50;
marker_distance = 1;


original_graph_size = 2113;     % change graph size here

% x_k = 1:node_scale;
% x_fraction = x_k/node_scale;

% tech-routers-rf is Rocketfuel Network (directed) (2113 nodes)
% CollegeMsg is UCI Social Network (directed) (1893 nodes)
% email-Eu is EU Email Network (undirected) (930 nodes)
% ia-email-univ is URV Email Network (undirected) (1133 nodes)
metric_num = length(metric_name);
for index = 1:metric_num
    num_comp = readmatrix(strcat('data/R3/directed/tech-routers-rf/',metric_name(index)));  % CHANGE
    simulation_time = num_comp(end);
    run_time = readmatrix(strcat('data/R3/directed/tech-routers-rf/',metric_name(index),'_runtime'));  % CHANGE
    
    disp(metric_name(index));
    disp(run_time);
    run_time_sum = sum(run_time);
    
    if simulation_time == 1
        metric_name(index) = strcat(metric_name(index), "*");
    elseif simulation_time == 100
        metric_name(index) = strcat(metric_name(index));
    else
        disp("show simulate time");
        metric_name(index) = strcat(metric_name(index), " (simu ", num2str(simulation_time), " times)");
    end
    
    num_comp = num_comp(1:end-1);
    
    node_scale = length(num_comp);
    x_k = 1:node_scale;
    x_fraction = x_k/100;
    
    num_comp = num_comp/original_graph_size;% *100; % to fraction
    p = plot(x_fraction, num_comp, marker_shape(index), 'MarkerIndices',1:marker_distance:length(num_comp));
%     xtickformat('percentage');
%     ytickformat('percentage');
    
    p.MarkerSize = plot_size*12;
    p.LineWidth = plot_size;
%     text(x_fraction, num_comp+0.002,string(run_time),'HorizontalAlignment','center');
    hold on;
end
hold off;

metric_name_without_underscore = strrep(metric_name, '_', ' ');
% if metric_name_without_underscore(6)=="mixed degree decomposition"
%     metric_name_without_underscore(6) = "mixed degree dec.";
% end
if length(metric_name_without_underscore) >= 3
    if metric_name_without_underscore(3)=="mixed degree decomposition"
        metric_name_without_underscore(3) = "mixed degree dec.";
    end
end
% legend boxoff  % remove the box of legend
lgd = legend(metric_name_without_underscore, 'location', 'southwest');
set(lgd,'color','none')     % make legend transparent
% set(lgd,'Interpreter', 'none')
lgd.FontSize = font_size;
xlabel('fraction of initial attackers', 'FontSize',font_size);
ylabel('Size of the giant component', 'FontSize',font_size);
set(gca,'FontSize',font_size);
set(gca,'XLim',[0.01 0.1]);  % set windows area
disp(get(gca,'colororder'));
% ylim([1.2 2]);
% ylim([0.7 0.99]);