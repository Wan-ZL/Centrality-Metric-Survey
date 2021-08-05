function f = fvector3(A)

f = [];

num = 1;
count = 0;
while num
    num = getfacenumber3(A,count);
    if num~=0
        count = count + 1;
        f(count,1) = num;
    end
end

    