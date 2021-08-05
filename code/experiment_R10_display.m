clear; clc; clf;

% Uncomment code for specific dataset and metric. To use metric, edit function name wih label "CHANGE HERE". 

% CHANGE parameter here
metric_name = ["degree_distance","single_discount","degree_discount","degree_punishment","collective_influence"];


% marker_shape = ["-ko", "-p", "-*", "-^", "-+", "-.", "-x", "-s", "-v", "-d", "->", "-<", "-h"];
marker_shape = ["-p", "-*", "-^", "-+", "-.", "-x", "-s", "-v", "-d", "->", "-<", "-h"];
plot_size = 2.5;
font_size = 45;
marker_distance = 50;



metric_num = length(metric_name);
best_one_position = 0;
for index = 1:metric_num
    num_comp = readmatrix(strcat('data/R10/infectious/email-Eu/',metric_name(index)));  % CHANGE
    simulation_time = num_comp(end);
    run_time = readmatrix(strcat('data/R10/infectious/email-Eu/',metric_name(index),'_runtime'));  % CHANGE
    disp(run_time)
%     metric_name(index) = strcat(metric_name(index), " (", num2str (run_time), "s per simu) (simu ", num2str(simulation_time), " times)");
    if simulation_time == 1
        metric_name(index) = strcat(metric_name(index), "*");
    elseif simulation_time == 100
        metric_name(index) = strcat(metric_name(index));
    else
        disp("show simulate time");
        metric_name(index) = strcat(metric_name(index), " (simu ", num2str(simulation_time), " times)");
    end
    
    num_comp = num_comp(1:end-1);
    
%     find the optimal display x-axis range
    one_position = find(num_comp==1);
    if one_position(1) > best_one_position
        best_one_position = one_position(1);
    end
    
    
    node_scale = length(num_comp);
    x_k = 0:node_scale-1;
%     x_fraction = x_k/node_scale;
    
    num_comp = num_comp/node_scale; % to fraction
    p = plot(x_k, num_comp, marker_shape(index), 'MarkerIndices',1:marker_distance:length(num_comp));
    p.MarkerSize = plot_size*12;
    p.LineWidth = plot_size;
    hold on;
end
hold off;

metric_name_without_underscore = strrep(metric_name, '_', ' ');
% if metric_name_without_underscore(6)=="mixed degree decomposition"
%     metric_name_without_underscore(6) = "mixed degree dec.";
% end
lgd = legend(metric_name_without_underscore);
% set(lgd,'Interpreter', 'none')
lgd.FontSize = font_size*1; % was 1.1
xlabel('number of groups removed', 'FontSize',font_size);
ylabel('size of the giant component', 'FontSize',font_size);
set(gca,'FontSize',font_size)

% xlim([0 best_one_position]);
xlim([0 150]);