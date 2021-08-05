clear; clc; clf;

% Uncomment code for specific dataset and metric. To use metric, edit function name wih label "CHANGE HERE". 

font_size = 40;
% 
% fileID = fopen('data/ia-email-univ.txt','r');   % File locaton (Change)
% formatSpec = '%i %i';   % file format (Change)
% sizeA = [2 Inf]; % variable format (Change)
% file_data = fscanf(fileID,formatSpec,sizeA);
% % file_data = file_data';
% % file_data = file_data +1;   % if node id start from 0, keep this one. Otherwise, comment it out.
% 
% % generate graph
% G = digraph(file_data(1,:), file_data(2,:)); %directed graph or undirected graph?


% % % My graph: ia-email-univ ================
% fileID = fopen(strcat('data/ia-email-univ.txt'),'r');
% formatSpec = '%i %i';
% sizeA = [2 Inf];
% file_data = fscanf(fileID,formatSpec,sizeA);
% 
% % file_data = file_data +1;
% 
% % generate graph
% G = graph(file_data(1,:), file_data(2,:));
% % =========================

% % My graph: CollegeMsg ================
% fileID = fopen(strcat('data/CollegeMsg.txt'),'r');
% formatSpec = '%i %i %i';
% sizeA = [3 Inf];
% file_data = fscanf(fileID,formatSpec,sizeA);
% 
% % file_data = file_data +1;
% 
% % generate graph
% G = digraph(file_data(1,:), file_data(2,:));
% % =========================

% Yash graph: email-Eu ==============
data = load(strcat('data/email-Eu.mat'));
G = graph(data.Problem.A, 'upper');


[bin,binsize] = conncomp(G);
idx = binsize(bin) == max(binsize);
G = subgraph(G, idx);
% =========================

% % Yash graph: tech-routers-rf ==============
% fileID = fopen(strcat('data/tech-routers-rf.mtx'),'r');
% formatSpec = '%i %i';
% sizeA = [2 Inf];
% file_data = fscanf(fileID,formatSpec,sizeA);
% 
% % file_data = file_data +1;
% 
% % generate graph
% G = digraph(file_data(1,:), file_data(2,:));
% % % =========================

% get largest connected component
% [bin,binsize] = conncomp(G,'Type','weak');    % direct or undirect
[bin,binsize] = conncomp(G);
idx = binsize(bin) == max(binsize);
sub_G = subgraph(G, idx);

node_scale = numnodes(sub_G);
disp(node_scale);

subplot(1,2,1);
plot(sub_G, 'Layout','force','NodeColor','k','EdgeColor','k'); %, 'Layout','auto');         %initial graph
xlabel(strcat('Network (', int2str(node_scale), " nodes)"), 'FontSize',font_size);

subplot(1,2,2);
% degrees = indegree(sub_G) + outdegree(sub_G);    % direct or undirect
degrees = degree(sub_G);
histogram(degrees,'FaceColor','k');
xlabel('Node Degree', 'FontSize',font_size);
ylabel('Number of Node', 'FontSize',font_size);
set(gca,'FontSize',font_size)