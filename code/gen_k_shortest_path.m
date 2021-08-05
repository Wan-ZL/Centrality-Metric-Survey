function [shortestPaths, totalCosts] =  ...
            gen_k_shortest_path(weight_matrix, src, dst, k, ...
            output_file, demand_id)
 
fileID = fopen(output_file,'at');
 
 
%------Call kShortestPath------:
[shortestPaths, totalCosts] = kShortestPath(weight_matrix, src, dst, k);
 
%------Display results------:
if isempty(shortestPaths)
    fprintf(fileID,'No path available between these nodes\n\n');
else
    for i = 1: length(shortestPaths)
        %fprintf(fileID,'Path # %d: %d %d : ',i, src, dst);
        fprintf(fileID,'%d %d ', src, dst);
        %disp(shortestPaths{i});
        len = length(shortestPaths{i});
        for j = 1: len - 1
            fprintf(fileID, '%d ', shortestPaths{i}(j));
        end
        fprintf(fileID,'%d', shortestPaths{i}(len));
        %fprintf(fileID,'x_%d_%d \n', demand_id, i);
        fprintf(fileID,'\n');
        %fprintf(fileID,'Cost of path %d is %5.2f\n\n',i,totalCosts(i));
    end
end
fclose(fileID);
