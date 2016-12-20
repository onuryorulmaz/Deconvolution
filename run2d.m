clc 
clear
close all

x = double(imread('barbara.png'))/255;
x = x(1:282, 231:end);
padsize = 20;
x = padarray(x, [padsize, padsize], 'replicate', 'both');
x = padarray(x, 50*[1, 1], 'both');

padsize  = 70;
h = fspecial('disk', 8);
%h = fspecial('motion', 12, 5);

%zz = zeros(2*size(x));
%zz(size(zz,1)*0.25+1:end-size(zz,1)*0.25, size(zz,2)*0.25+1:end-size(zz,2)*0.25) = x;
%x =zz;
stdDev = 0.01;

%x = x(1:2:end,1:2:end);
%h = conv2(([1 2 3 2 1]/9)',([1 2 3 2 1])/9); %must have odd number of elements

lambda = 0.05;
y = conv2(x,h,'same');

%mask = zeros(size(y));
%mask(size(y,1)*0.25+1:end-size(y,1)*0.25, size(y,2)*0.25+1:end-size(y,2)*0.25) = 1;

%y = y(10:end-9,10:end-9);

noise = stdDev * randn(size(y));
y = y + noise;



es_x = ones(size(y,1), size(y,2));

hsize = size(h);

    subplot(2,2,1); imshow(x(21:end-20,21:end-20))
    subplot(2,2,2); imshow(y(21:end-20,21:end-20))
numIter = 30;
for it = 1: numIter
    it
    x_prev = es_x;
    for i = (hsize(1)+1)/2:size(y,1)-(hsize(1)-1)/2
        for j = (hsize(2)+1)/2:size(y,2)-(hsize(2)-1)/2
            window = es_x(i-(hsize(1)-1)/2:i+(hsize(1)-1)/2,j-(hsize(2)-1)/2:j+(hsize(2)-1)/2);

            window = window + lambda * ((y(i,j) - (h(:)' * window(:))) / (h(:)' * h(:))) * h;
            es_x(i-(hsize(1)-1)/2:i+(hsize(1)-1)/2,j-(hsize(2)-1)/2:j+(hsize(2)-1)/2) = window;
        end
    end
    subplot(2,2,3); imshow(es_x)
    
    es_x = replaceFourierPhase(es_x, y, h);
        
    es_x = reshape(projL1Est(es_x(:), sum(es_x(:)) * 0.87), size(y));

    %es_x = reshape(projHighFreqL1(es_x, 1), size(y));
    %es_x = reshape(projHighFreqL1(es_x, 2), size(y));
    
    
    err = mean(mean(abs(x-es_x).^2));
    10*log10(1/err)


    subplot(2,2,4); imshow(es_x(padsize+1:end-padsize, padsize+1:end-padsize));
    pause(0.1);
    
    diff = abs(x_prev -es_x);
    if(mean(diff(:)) < 0.0005)
        break;
    end
    mean(diff(:))
end

lenh = length(h);
%es_x = es_x((hsize(1)+1)/2:end - (hsize(1)-1)/2, (hsize(2)+1)/2:end - (hsize(2)-1)/2);

subplot(1,3,1)
imshow(x(padsize+1:end-padsize, padsize+1:end-padsize),[]);
subplot(1,3,2)
imshow(es_x(padsize+1:end-padsize, padsize+1:end-padsize));
subplot(1,3,3)
imshow(y(padsize+1:end-padsize, padsize+1:end-padsize),[]);

