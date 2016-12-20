clc 
clear
close all

x = [1 1 1 2 2 2 5 2 2 1 2 2 2 6 6 6 6  6 6 6 6 6 5 5 5 4 4 4 4  3 3 3 3];
h = [1/4 1/2 1/4]; %must have odd number of elements
lambda = 0.0015;
y = conv(x,h);

es_x = ones(1, length(y));

numIter = 100000;
for it = 1: numIter
    for i = 2:length(y)-1;
        window = es_x(i-1:i+1);
                
        window = window + lambda * ((y(i) - h * window') / (h * h')) * h;
        es_x(i-1:i+1) = window;
    end
end

lenh = length(h);
es_x = es_x((lenh+1)/2:end - (lenh-1)/2);

plot(x);
hold on
plot(es_x);
plot(y);

legend('x','estimate of x', 'y = x * h');