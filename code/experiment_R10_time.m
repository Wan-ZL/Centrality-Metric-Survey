clear; clc; clf;

% Uncomment code for specific dataset and metric. To use metric, edit function name wih label "CHANGE HERE". 

% CHANGE parameter here
metric_name = ["degree_distance","single_discount","degree_discount","degree_punishment","collective_influence"];
font_size = 25;


metric_num = length(metric_name);
run_time_IA = zeros(metric_num,1);
run_time_EM = zeros(metric_num,1);


% read all data from undirected folder
for index = 1:metric_num
    run_time = readmatrix(strcat('data/R10/non-infectious/ia-email-univ/',metric_name(index),'_runtime'));  % CHANGE
    run_time_IA(index) = run_time;
    disp(run_time);
end

% read all data from directed folder
for index = 1:metric_num
    run_time = readmatrix(strcat('data/R10/non-infectious/email-Eu/',metric_name(index),'_runtime'));  % CHANGE
    run_time_EM(index) = run_time;
    disp(run_time);
end

% % add star(*) for directed graph
% metric_name = strcat(metric_name, '*');
% disp(metric_name);


% combine two array
% metric_name_all = [metric_name_undirected metric_name];

% sort
[sorted_time_list_IA, sort_order_IA] = sort(run_time_IA);
for index = 1:metric_num
    sorted_time_list_EM(index) = run_time_EM(sort_order_IA(index));
end

% [sorted_time_list_IA, sort_order_IA] = sort(run_time_IA);

metric_name_without_underscore = strrep(metric_name(sort_order_IA), '_', ' ');
% metric_name_without_underscore_IA = strrep(metric_name(sort_order_IA), '_', ' ');


X_order = categorical(metric_name_without_underscore);
X_order = reordercats(X_order,metric_name_without_underscore);

% X_order_IA = categorical(metric_name_without_underscore_IA);
% X_order_iA = reordercats(X_order_IA,metric_name_without_underscore_IA);


sorted_time_list = [sorted_time_list_IA sorted_time_list_EM'];
disp(sorted_time_list);

% display
b = bar(X_order, sorted_time_list, 'FaceColor', '#283747');

% set bar color
b(1).FaceColor = '#283747';
b(2).FaceColor = '#e67d23';

% legend
legend('URV Email Network','EU Email Network');


% xlabel('group selection metrics','FontSize',font_size);
ylabel('Running Time per Simulation (sec. in log)','FontSize',font_size);
set(gca,'FontSize',font_size,'YScale','log');
