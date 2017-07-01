function [ es_x ] = projDeconv(img, y, h, numIter )

mask = ones(size(y));
mask = padarray(mask, [20,20], 'both');
maskBl = conv2(mask,h,'same');

%y = medfilt2(y,[5 5]);
y = padarray(y,[20,20], 'replicate', 'both');
y = y .* maskBl; %ready to extrat phase;



es_x = ones(size(y));

psnr_vec = 0;

hsize = size(h);

lambda = 0.05;

for it = 1: numIter
    fprintf('Ýteration: %d\n', it);
    x_prev = es_x;
    
    
    
    for i = (hsize(1)+1)/2:size(y,1)-(hsize(1)-1)/2
        for j = (hsize(2)+1)/2:size(y,2)-(hsize(2)-1)/2
            window = es_x(i-(hsize(1)-1)/2:i+(hsize(1)-1)/2,j-(hsize(2)-1)/2:j+(hsize(2)-1)/2);

            window = window + lambda * ((y(i,j) - (h(:)' * window(:))) / (h(:)' * h(:))) * h;
            es_x(i-(hsize(1)-1)/2:i+(hsize(1)-1)/2,j-(hsize(2)-1)/2:j+(hsize(2)-1)/2) = window;
        end
    end
    
    es_x = replaceFourierPhase(es_x, y, h);
        
    es_x = reshape(projL1Est(es_x(:), sum(es_x(:)) * 0.87), size(y));

    hHP = fftshift(-h);
    hHP(1,1) = 1+hHP(1,1);
    hHP = ifftshift(hHP);
    highComponent = conv2(es_x, hHP, 'same');
    es_x = conv2(y, h, 'same') + .9*highComponent;
    
    
    psnr_val = psnr(es_x(21:end-20,21:end-20), img);
    psnr_vec(it) = psnr_val;

    fprintf('Error : %.2fdB\n', psnr_val);
    
    
    subplot(2,2,1)
    imshow(img, []);
    title('Original Image');
    subplot(2,2,2)
    imshow(es_x(21:end-20,21:end-20),[]);
    title('Deconvolved Image');
    subplot(2,2,3)
    imshow(y(21:end-20,21:end-20),[]);
    title('Blurred Image');

    subplot(2,2,4);
    plot(psnr_vec);
    title('PSNR vs Iterations');
    xlabel('iterations');
    ylabel('PSNR (dB)');
    pause(0.1);
    
    diff = abs(x_prev -es_x);
    
    if(mean(diff(:)) < 0.0001)
        break;
    end
end


end

