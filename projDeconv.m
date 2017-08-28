function [ es_x ] = projDeconv(img, y, h, numIter )
% projDeconv(img, y, h, iter)
%  Iteratively deconvolves image y which is blurred by zero phase filter h,
% by projections onto convex sets in iter number of iterations. The 
% original image img is needed only to supply PSNR results to the user.
% 
% example: 
%  x = imread('cameraman.tif');
%  x = double(x)/255;
%  h = fspecial('disk', 13);
%  y = conv2(x,h,'same');
%  estimate_x = projDeconv(x, y, h, 25);

mask = ones(size(y));
mask = padarray(mask, [20,20], 'both');
%blurred mask is used for extending y with a gradient
maskBl = conv2(mask,h,'same');

y = padarray(y,[20,20], 'replicate', 'both');
y = y .* maskBl;

%y is now going towards zero on edges gradually.

%initial estimate
es_x = ones(size(y));

psnr_vec = 0;

hsize = size(h);

lambda = 0.05;

for it = 1: numIter
    fprintf('Ýteration: %d\n', it);
    x_prev = es_x;
    
    
    % any value in y can be written as sum of elementwise multiplication of
    % h and corresponding window on x. make a little correction on x to fit
    % y = x * h
    for i = (hsize(1)+1)/2:size(y,1)-(hsize(1)-1)/2
        for j = (hsize(2)+1)/2:size(y,2)-(hsize(2)-1)/2
            window = es_x(i-(hsize(1)-1)/2:i+(hsize(1)-1)/2,j-(hsize(2)-1)/2:j+(hsize(2)-1)/2);

            window = window + lambda * ((y(i,j) - (h(:)' * window(:))) / (h(:)' * h(:))) * h;
            es_x(i-(hsize(1)-1)/2:i+(hsize(1)-1)/2,j-(hsize(2)-1)/2:j+(hsize(2)-1)/2) = window;
        end
    end
    % extract Fourier transform phase of extended y and replace Fourier
    % transform phases of x wit these values
    es_x = replaceFourierPhase(es_x, y, h);
        
    % Project onto L1 estimate
    % 0.87 defines epsilon. if this value is so small, all pixels go to 0.
    % if this value is 1, projection is equal to the image itself.
    es_x = reshape(projL1Est(es_x(:), sum(es_x(:)) * 0.87), size(y));

    % reduce contribution of high frequency components by 10 percent.
    hHP = fftshift(-h);
    hHP(1,1) = 1+hHP(1,1);
    hHP = ifftshift(hHP);
    highComponent = conv2(es_x, hHP, 'same');
    es_x = conv2(y, h, 'same') + .9*highComponent;
    
    % calculate psnr for current iterate.
    psnr_val = psnr(es_x(21:end-20,21:end-20), img);
    psnr_vec(it) = psnr_val;

    fprintf('PSNR : %.2fdB\n', psnr_val);
    

    %plot results
    subplot(3,2,1)
    imshow(img, []);
    title('Original Image');
    subplot(3,2,2)
    imshow(es_x(21:end-20,21:end-20),[]);
    title('Deconvolved Image');
    subplot(3,2,3)
    imshow(y(21:end-20,21:end-20),[]);
    title('Blurred Image');

    subplot(3,2,4);
    plot(psnr_vec);
    title('PSNR vs Iterations');
    xlabel('iterations');
    ylabel('PSNR (dB)');
    pause(0.1);
    
    % iteration break condition is that successive iterates are similar to
    % each other.
    diff = abs(x_prev -es_x);
    
    if(mean(diff(:)) < 0.0001)
        break;
    end
end



    es_x = es_x(21:end-20,21:end-20);
    
    % show results of well known methods for the same image.
    wi = deconvwnr(y, h, 0.01);
    subplot(3,2,5)
    imshow(wi);
    title('Wiener');
   lu = deconvlucy(y, h);
    subplot(3,2,6)
    imshow(lu);
    title('Lucy');

end

