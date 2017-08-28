function [ arr ] = projL1Est( input , eps)
%PROJL1 Summary of this function goes here
%   Detailed explanation goes here
eps1 = eps;
eps2 = eps;


signs = sign(input);
arr = abs(input);


normArr = sqrt(arr'*arr);
if(normArr > eps2)
    coeff = eps2 / normArr;
    arr = arr * coeff;
end

cursum = sum(arr(:));
if(cursum > eps1)
    arr = arr - cursum / length(arr) + eps1 / length(arr);
end

arr(arr < 0) = 0;
arr = arr .* signs;

end

