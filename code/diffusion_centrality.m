function DC = diffusion_centrality(graph_matrix, T, q)
%	Input:  graph_matrix: adjacency matrix
%           T: number of iteration (in test, I use T = 10, in test)
%           q: passing probability (in test, transform the edge value to probability interpretaion
%                                   weight_matrix * 0.2. weight_matrix is
%                                   N*N)
% 
%   Output: DC:  Diffusion Centrality
% 
%   Author: Zelin
% 
%   Reference: A. Banerjee, A. G. Chandrasekhar, E. Duflo, and
%   M. O. Jackson, “The diffusion of microfinance,” Science, vol. 
%   341, no. 6144, p. 1236498, 2003. [Online]. Available: 
%   http://science.sciencemag.org/content/341/6144/1236498
% 
%   https://rdrr.io/cran/keyplayer/man/diffusion.html
% 

node_number = length(graph_matrix);
                                           
vect_ones = ones(node_number, 1);             % vector of ones

DC = zeros(node_number, 1);

% skip_graph = graph_matrix * ones(node_number,1) + graph_matrix' * ones(node_number,1);



for t = 1: length(T)                    % riemann sum
    
    DC = DC + ((q * graph_matrix).^t * vect_ones);
    
    
end


% for i = 1:node_number
%     if skip_graph(i) == 0        % set deleted node as zero
%         DC(i) = 0;
%     end
% end


end

