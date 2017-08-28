function [ out ] = replaceFourierPhase( im, blurred, h)
%REPLACEFOURIERPHASE Summary of this function goes here
%   Detailed explanation goes here

filter = h;
filter(size(blurred,1), size(blurred, 2)) = 0;

filter = circshift(filter, -(size(h)-1)/2);

fFilter = fft2(filter);

filterCorrection = real(fFilter < 0);

fBlurred = fft2(fftshift(blurred));
fIm = fft2(fftshift(im));

fOut = abs(fIm) .* exp((angle(fBlurred) + filterCorrection * pi)* 1i);

out = ifftshift(real(ifft2(fOut)));

end

