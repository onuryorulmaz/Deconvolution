
clc 
clear
close all

fileName = 'lena.png';

img = double(imread(fileName))/255;

h = fspecial('disk', 9);

%h = fspecial('gaussian', [21,21],4);
[y, img] = blurImage(img, h);


numIter = 50;

es_x = projDeconv(img, y, h, numIter);
