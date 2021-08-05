clear; clc; clf;

% Uncomment code for specific dataset and metric. To use metric, edit function name wih label "CHANGE HERE". 

% CHANGE parameter here
metric_name_undirected = ["distance_based_GC", "degree_based_GC","betweenness_based_GC","flow_betweenness_GC", "closeness_based_GC","k_component","degree_assortativity","local_assortativity","graph_curvature" ,"global_clustering"];
no_text_metric = ["k_plex", "k_clique", "k_core"];

font_size = 25;
pad_value = 0.02;

metric_num_undirected = length(metric_name_undirected);

GC_SGC_result_list = zeros(metric_num_undirected,6);
% read all data from undirected folder
for index = 1:metric_num_undirected
    all_result = readmatrix(strcat('data/R6/undirected/email-Eu/',metric_name_undirected(index)));  % CHANGE
    GC_SGC_result_list(index,:) = all_result(1:end-1);
    
    % add star(*) for one time simulation
    simulation_time = all_result(end);
    if simulation_time == 1
        metric_name_undirected(index) = strcat(metric_name_undirected(index), "*");
    elseif simulation_time == 100
        metric_name_undirected(index) = strcat(metric_name_undirected(index));
    else
        disp("show simulate time");
        metric_name_undirected(index) = strcat(metric_name_undirected(index), " (simu ", num2str(simulation_time), " times)");
    end
end

% add no-text-metric
metric_name_undirected = [metric_name_undirected no_text_metric];
metric_num_all = metric_num_undirected + length(no_text_metric);

% extract y value
y_value = zeros(metric_num_all,2);
for index = 1:metric_num_all
%     RGC = 1 - GC_x/GC_0
%    y_value(index,:) = [(1 - GC_SGC_result_list(index,5)/GC_SGC_result_list(index,4)) (1 - GC_SGC_result_list(index,6)/GC_SGC_result_list(index,4))];
    y_value(index,:) = [(1-0.3) (1-0.7)];
%    text();
end
% disp(GC_SGC_result_list(:,4:6));

% disp(y_value);


metric_name_without_underscore = strrep(metric_name_undirected, '_', ' ');
X_order = categorical(metric_name_without_underscore);
X_order = reordercats(X_order,metric_name_without_underscore);
% X_order = reordercats(X_order,metric_name_undirected);
disp(X_order);
disp(y_value);
b = bar(X_order, y_value);

% set bar color
b(1).FaceColor = '#e67d23';
b(2).FaceColor = '#283747';


% text(b(1).XEndPoints, b(1).YEndPoints, num2str(GC_SGC_result_list(:,4)));

for two_bar_index = 1:2
    y_hgiht = b(two_bar_index).YEndPoints;

    for gc_index = 1:metric_num_undirected
        y_hgiht(gc_index) = y_hgiht(gc_index) + pad_value;
        if two_bar_index == 1
            text_value = (1 - GC_SGC_result_list(gc_index,5)/GC_SGC_result_list(gc_index,4));
        else
            text_value = (1 - GC_SGC_result_list(gc_index,6)/GC_SGC_result_list(gc_index,4));
        end
        text(b(two_bar_index).XEndPoints(gc_index), y_hgiht(gc_index), num2str(round(text_value, 3)),'FontSize', font_size, 'horiz','center');
    end

end

% xlabel('graph centrality metrics', 'FontSize',font_size);
ylabel('Size of the giant component', 'FontSize',font_size);
set(gca,'FontSize',font_size);
ylim([0 1])

legend('30% nodes removed','70% nodes removed');