function nksimplices = getfacenumber3(adj,k)

if k==0
    nksimplices = length(adj);
    return
end

if k==1
    nksimplices = sum(diag(adj*adj))/2;
    return
end

if k==2
    nksimplices = sum(diag(adj*adj*adj))/6;
    return
end

if k>=3
    temp = 0;
    for i=1:length(adj)
        [ii,jj]=find(adj(:,i));
        if ~isempty(ii)
            ii=unique(ii);
            mm=adj(ii,ii);
            temp = temp + getfacenumber3(mm,k-1);
        end
%         if k==6
%             disp(length(adj)-i)
%         end
    end
    nksimplices = temp/(k+1);
    return
end


