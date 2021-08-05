function [kcore] =k_core(G)
%KCORE - calculates K-core of network

% Input: Graph object
% Output: K-core
% Reference: M. Newman, Networks: an introduction. New York, NY, USA:
%               Oxford University Press, Inc., 2010.
%
% addpath(genpath('matlab_bgl'));
kcore = core_numbers(adjacency(G));
disp(kcore);
kcore = length(max(kcore));


