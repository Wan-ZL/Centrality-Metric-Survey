X = ["A" "M" "P" "U" "T" "A" "T" "I" "O" "N"];
Y = ["S" "P" "A" "N" "K" "I" "N" "G"];
[c_result, b_result] = LCS(X,Y);
disp(b_result+c_result);

function [c,b] = LCS(X,Y)
m = X.length;
n = Y.length;

b = strings(m+1,n+1);
c = zeros(m+1,n+1);

for i = 2:(m+1)
    c(i,1) = 0;
end
for j = 1:(n+1)
    c(1,j) = 0;
end
for i = 2:(m+1)
    for j = 2:(n+1)
        if X(i-1) == Y(j-1)
            c(i,j) = c(i-1,j-1)+1;
            b(i,j) = "\ ";
        elseif c(i-1,j) >= c(i,j-1)
            c(i,j) = c(i-1,j);
            b(i,j) = "| ";
        else
            c(i,j) = c(i,j-1);
            b(i,j) = "—— ";
        end
    end
end
c = string(c);
end