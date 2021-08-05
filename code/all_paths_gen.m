function [] = all_paths_gen(weight_matrix, k, output_file)
 
len = length(weight_matrix);
fileID = fopen(output_file,'wt');
fprintf(fileID,'%d nodes \n\n', len);
fclose(fileID);
 
node_pairs = combnk(1:len,2);
 
for index = 1: length(node_pairs)
    src = node_pairs(index, 1);
    dst = node_pairs(index, 2);
    gen_k_shortest_path(weight_matrix, src, dst, k, output_file, index);
end
end