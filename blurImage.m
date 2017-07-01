function [ y, img ] = blurImage( img , h )
%BLURIMAGE Summary of this function goes here
%   Detailed explanation goes here

padsize = 20;
img = padarray(img, [padsize, padsize], 'replicate', 'both');
img = padarray(img, 50*[1, 1], 'both');

%h = fspecial('motion', 12, 5);

stdDev = 0.01;

y = conv2(img,h,'same');

noise = stdDev * randn(size(y));
y = y + noise;

end

