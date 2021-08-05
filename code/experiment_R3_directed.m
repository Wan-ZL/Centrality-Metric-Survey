clear; clc; clf;

% Uncomment code for specific dataset and metric. To use metric, edit function name wih label "CHANGE HERE". 

% set workers
% delete(gcp('nocreate'));
% parpool(32); % this value can get from displayed infomation
disp(evalc('feature(''numcores'')'));


metric_name = 'random'; % CHANGE
simulation_time = 100;
infection_rate = 0.05;
attack_fraction = 10; % if 10, then from 1/attack_divide_base to 10/attack_divide_base
attack_divide_base = 100; % if 100, then means start from attack_fraction/100
dataset = 'tech-routers-rf';

% % My graph ================
% fileID = fopen(strcat('data/',dataset,'.txt'),'r');
% formatSpec = '%i %i %i';
% sizeA = [3 Inf];
% file_data = fscanf(fileID,formatSpec,sizeA);
% 
% % file_data = file_data +1;
% 
% % generate graph
% G = digraph(file_data(1,:), file_data(2,:));
% % =========================

% Yash graph ==============
fileID = fopen(strcat('data/',dataset,'.mtx'),'r');
formatSpec = '%i %i';
sizeA = [2 Inf];
file_data = fscanf(fileID,formatSpec,sizeA);

% file_data = file_data +1;

% generate graph
G = digraph(file_data(1,:), file_data(2,:));
% % =========================


% add weight property (1 if not given)
G.Edges.Weight = ones(numedges(G),1);

% add Immunity and Infected property
G.Nodes.Immunity = false(numnodes(G),1);
G.Nodes.Infected = false(numnodes(G),1);


% original_graph_size = numnodes(G);
% disp(G)
% plot(G); %, 'Layout','force');         %initial graph
% xlabel('original network');

% get largest component
[bin,binsize] = conncomp(G,'Type','weak');
idx = binsize(bin) == max(binsize);

node_scale = length(idx);


num_comp_matrix = zeros(simulation_time,attack_fraction);
run_time_maxtrix = zeros(simulation_time,attack_fraction);
% simulation times

sub_G = subgraph(G, idx);
disp(sub_G)
plot(sub_G); %, 'Layout','force');         %initial graph
xlabel('original network');
parfor iteration = 1:simulation_time
    disp(['Iteration: ' int2str(iteration)]);

    
%     while nodes_num>1
    for k = 1:attack_fraction
        tStart = tic;
        disp(['attack fraction: ' int2str(k)]);
        
        % get largest component
        sub_G = subgraph(G, idx);
        nodes_num = numnodes(sub_G);
        

        if nodes_num == 0
            disp("nodes_num is 0");
            continue;
        end
        
        attack_num = int64(nodes_num*k/attack_divide_base);
        

        % remove node                                   (CHANGE HERE)
        Dc = randperm(nodes_num,nodes_num); % remove random id
%         Dc = mixed_degree_decomposition(full(adjacency(sub_G)), 0.5);
%         Dc = SALSA_hubs(sub_G,2);
%         Dc = centrality(sub_G,'authorities')';

        % avoid NaN Error
        Dc(isnan(Dc)) = 0;
        
        % sort from highest to lowest
        [~, Dc_indexs] = sort(Dc,'descend');

        % get attacked nodes
        attack_nodes_IDs = Dc_indexs(1:attack_num);
        
        % add successor for infection process
        sub_G.Nodes.Infected(attack_nodes_IDs) = true;
        attack_nodes_successors = [];
        for i = 1:length(attack_nodes_IDs)
            attack_nodes_successors = [attack_nodes_successors successors(sub_G,attack_nodes_IDs(i))'];
        end
        
        % remove duplicate
        attack_nodes_successors = unique(attack_nodes_successors,'stable');
        
        % infectious attacks
        sub_G = infect_proccess(sub_G, attack_nodes_successors, infection_rate);
%         for i = 1:attack_num
%             [infected_nodes, sub_G] = infect_proccess(sub_G, remove_nodes(i), infection_rate);
%             remove_nodes_with_successors = [remove_nodes_with_successors infected_nodes];
%         end
        infect_result = sub_G.Nodes.Infected;

        infected_Node_ID = find(infect_result == true);
%         disp(length(infected_Node_ID));
        
%         % remove duplicate IDs
%         remove_nodes_with_successors = unique(remove_nodes_with_successors);
        

        sub_G = rmnode(sub_G, infected_Node_ID);
        
        % store largest connected component
        [~,components] = conncomp(sub_G,'Type','weak');

        if ~isempty(components)
            num_comp_matrix(iteration,k) = max(components); % get sum result
        end

        
        % restore time
        tEnd = toc(tStart);
        run_time_maxtrix(iteration,k) = tEnd;
%         disp(tEnd);
%         disp(max(components));
    end
    
end

% matrix to array
num_comp = sum(num_comp_matrix, 1); 
run_time = sum(run_time_maxtrix, 1);

% get average result
num_comp = int64(num_comp/simulation_time); % round double to integer
run_time = run_time/simulation_time;

% remove unused part
num_comp = nonzeros(num_comp);
run_time = nonzeros(run_time);

% last number is  "simulation time"
num_comp(end+1) = simulation_time;


% write to file 
% writematrix(num_comp,strcat('data/',metric_name)); % this only for matlab 2019a
fileID_metric = fopen(strcat('data/R3/directed/',dataset,'/',metric_name,'.txt'),'w');
if fileID_metric == -1
  error('Author:Function:OpenFile', 'Cannot open file');
end
fprintf(fileID_metric, '%d,', num_comp(1:end-1));
fprintf(fileID_metric, '%d', num_comp(end));


% write run time to file
% run_time = tEnd/simulation_time;
% disp(run_time);

fileID_metric_runtime = fopen(strcat('data/R3/directed/',dataset,'/',metric_name,'_runtime.txt'),'w');
if fileID_metric_runtime == -1
  error('Author:Function:OpenFile', 'Cannot open file');
end
fprintf(fileID_metric_runtime, '%d,', run_time(1:end-1));
fprintf(fileID_metric_runtime, '%d', run_time(end));

fclose(fileID_metric);
fclose(fileID_metric_runtime);
fclose(fileID);

disp(node_scale);





function sub_G = infect_proccess(sub_G, node_try_array, infection_rate)
% loop untile remove_nodes empty

% pre_save for speed up
Immunity_array = sub_G.Nodes.Immunity;
Infected_array = sub_G.Nodes.Infected;

while(~isempty(node_try_array))
%     disp(length(node_try_array));
    % always try first element
    % only try untouched node
    if (~Immunity_array(node_try_array(1))) && (~Infected_array(node_try_array(1)))
        if rand < infection_rate
            % infect
            % set infection
            Infected_array(node_try_array(1)) = true;

            % add successor into try_queue
            successor_nodes = successors(sub_G,node_try_array(1))';
            node_try_array = [node_try_array successor_nodes];

            % remove duplicate
            node_try_array = unique(node_try_array,'stable');
        else
            % uninfect
            Immunity_array(node_try_array(1)) = true;
        end
    end
    % remove current node from queue
%     node_try_array = node_try_array(2:end);
    node_try_array(1) = [];
end
% save label
sub_G.Nodes.Immunity = Immunity_array;
sub_G.Nodes.Infected = Infected_array;


end

