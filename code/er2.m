function [G] = er2(N, p)

rng shuffle;
% N: total nodes
% p: rewiring prob.
M = zeros(N, N);

for i=1:N
   for j=i+1:N
       if M(i,j) ==0 && rand < p
           M(i, j) = 1;
           M(j, i) = 1;
       end
   end
end

[x,y]=getNodeCoordinates(N);
%M=M+fliplr((flipud(triu(M))));
G=struct('Adj',M,'x',x','y',y','nv',N,'ne',nnz(M));
% display('er');