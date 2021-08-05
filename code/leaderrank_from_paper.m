function Cl = leaderrank_from_paper(E)
% This is a Matlab M−file for LeaderRank.
% E=load('Network.dat'); % Read the network data with different pairs
%                         % of ‘ fan leader ’ in consecutive rows , and the 
%                         % labels of nodes should start from 1

l=length(E); % l is the number of links
N=max(max(E)); %N is the number of nodes.


% Add ground node and create adjacency matrix P 
EG1= zeros(N ,2) ;
EG2= zeros(N ,2) ; 
for i=1:N
    EG1(i,1)=N+1;
    EG1(i,2)= i ; 
end
EG2(:,1)=EG1(: ,2); 
EG2(:,2)=EG1(: ,1); 
E=[E;EG1;EG2];
P=sparse(E(: ,1) ,E(: ,2) ,1);
D_in=sum(P); % in degree 
D_out=sum(P'); % out degree
% Transition matrix PP 
EE = zeros(N+1 ,2);
for j=1:N+1 
    EE( j ,1)= j ;
    EE(j,2)=1/D_out(j); 
end
D=sparse(EE(: ,1) ,EE(: ,1) ,EE(: ,2)); 
PP=D*P ;
% Diffusion to stable state . 
God= zeros( N + 1 , 1 ); 
God(1:N,1)=1;   % Assign initial resource
error=10000;    % error is the average error of nodes' scores. 
error_threshold=0.00002;    % It is a tunable parameter controlling the
                            % error tolerance .
step =1;
while error>error_threshold
    step 
    M=God;
    God=PP'*God;
    error=sum(abs(God-M)./M)/(N+1);
    step=step+1;
end
b=God(N+1)/N; 
God=God+b; 
God(N+1)=0;

% my code
Cl = God;

% % Write the ranking results to ”Results.dat”: node's ID & Score 
% R= zeros(N,2);
% R(:,1)=[1:N]';
% R(: ,2)=God(1:N);
% [ b, pos ] = sort( -R( :, 2 ));
% R=R(pos,: );
% fid = fopen('Results.dat','w'); 
% for i=1:N
%     fprintf(fid,'%d %f \n',R(i,1),R(i,2)); 
% end
% fclose(fid);