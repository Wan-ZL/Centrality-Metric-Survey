function [D] = ct_degree(A, n)

D = zeros(n, 2); %to list degree of nodes

for i = 1:n
    D(i, 2) = i;
    sum = 0;
    for j = 1:n
        if A(i,j) == 1
            sum = sum+1;
        end
    end
    D(i, 1) = sum;
end