function [ arr ] = projL1( input, eps )
%PROJL1 Summary of this function goes here
%   Detailed explanation goes here
input = input/eps;

signs = sign(input);
[arr, order] = sort(abs(input));

for i = 1:length(arr)
    if (abs(arr(i)) < 0.00000001 )
        continue
    end
    
    currsum = sum(arr(i:end));
    if(currsum <= 1)
        break;
    end
    
    if(currsum - arr(i) * (length(arr) - i +1) < 1)
        arr(i:end) = arr(i:end) - (currsum - 1)/(length(arr) - i +1);
        break;
    end
    
    arr(i:end) = arr(i:end) - arr(i);
    
end


arr(order) = arr;
arr = signs .* arr;

arr = arr*eps;
end

