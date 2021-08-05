clear; clc;
% 数据来源: https://usafactsstatic.blob.core.windows.net/public/data/covid-19/covid_confirmed_usafacts.csv
% (https://chinese.cdc.gov/coronavirus/2019-ncov/cases-updates/county-map.html)
% (https://usafacts.org/visualizations/coronavirus-covid-19-spread-map/)

Table = readtable('/Users/wanzelin/Downloads/covid_confirmed_usafacts.csv', 'HeaderLines',2);

matrix = table2array(Table(:,4:end));
disp(size(matrix));


counter = zeros(1,10);
for c = 1:3194
    disp(c);
    for i = 3:157
        str_element = num2str(matrix(1,i));
        digit = str2num(str_element(end));
%         disp(digit);
        if digit ~= 0
            counter(digit) = counter(digit) + 1;
        else
            counter(10) = counter(10) + 1;
        end
    end
end

disp(counter);

bar(counter(1:end-1));
text(1:length(counter),counter,num2str(counter'),'FontSize', 24,'vert','bottom','horiz','center');
set(gca,'FontSize',24);