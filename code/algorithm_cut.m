p = [1 5 8 9 10 17 17 20 24 30];

disp(botton_cut(p, 2, 10));

function r = botton_cut(p, c, n)
r = zeros(n,1);
r(1) = 0;

for j = 1:n
    q = p(j);
    for i = 1:j
%         q = max([q p(i)+r(j-i+1)-c]);
        if(j-i)==0
            q = max([q p(i)+r(j-i+1)]);
        else
            q = max([q p(i)+r(j-i+1)-c]);
        end
    end
    r(j+1) = q;
end
end