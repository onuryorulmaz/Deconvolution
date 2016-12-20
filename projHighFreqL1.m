function [ out ] = projHighFreqL1( im , filtId)
%PROJHÝGHFREQL1 Summary of this function goes here
%   Detailed explanation goes here
    

if filtId == 1
    lpFilter = [ 0 0 0; 0 0 1; 0 0 0];
else
    lpFilter = [ 0 0 0; 0 0 0; 0 1 0];
end
    
%lpfilter = [0 1 0 ; 1 0 1 ; 0 1 0];

%lpfilter = lpfilter/4;
    xlo = conv2(im , lpFilter, 'same');
    
    xhi = im - xlo;
    
    xhip = reshape(projL1Est(xhi(:), 0.8 * sum(abs(xhi(:)))), size(xlo));
    out = xlo + xhip;
end

