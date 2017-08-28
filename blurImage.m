function [ y, img ] = blurImage( img , h )

padsize = 20;
img = padarray(img, [padsize, padsize], 'replicate', 'both');

stdDev = 0.01;

y = conv2(img,h,'same');

noise = stdDev * randn(size(y));
y = y + noise;

img=img(1+padsize:end-padsize, 1+padsize:end-padsize);
y=y(1+padsize:end-padsize, 1+padsize:end-padsize);
end

