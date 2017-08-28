
clear
close all

fileName = 'barbara.png';

img = double(imread(fileName))/255;

h = fspecial('disk', 9);

%h = fspecial('gaussian', [21,21],4);
[y, img] = blurImage(img, h);

numIter = 25;

es_x = projDeconv(img, y, h, numIter);
