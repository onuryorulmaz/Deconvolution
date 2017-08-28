%tester
clear
clc

imageNum = [3096,12003,15001,15088,19021,22013,24004,29030,35049,41096,48017,69000,69015,...
100007,107045,135037,153077,226022,260081,302003];
%imageNum = [5 6 7 8 ];
numFiltersPerType = 3;
diskSize = [6 9 12];
gausSize = [4 7 11];

psnrDisk = zeros(1,1);
psnrGauss = zeros(1,1);
es_x = 0;
h = 0;

for psftye =1:2
    for i = 1:length(imageNum)
        for j = 1:numFiltersPerType
            %close all
            for offset = 0:numFiltersPerType:2*numFiltersPerType
                imIdx = imageNum(i);
                diskS = diskSize(j);
                gausS = gausSize(j);

                clc
                %load (['Levin09blurdata/im0' num2str(imIdx) '_flit01.mat'])
                x = imread(['BSD500\used\' num2str(imIdx) '.jpg']);
                x = rgb2gray(double(x)/255);
if psftye ==1
                h = fspecial('gaussian', [41 41], gausS );
else
                h = fspecial('disk', diskS );
end

                [y, img] = blurImage(x, h);

                numIter = 12;

        if offset == 0
                es_x = projDeconv(img, y, h, numIter);
        elseif offset == numFiltersPerType
                es_x = deconvwnr(y, h, 0.01);
                subplot(3,2,5)
                imshow(es_x);
                title('Wiener');
        elseif offset == 2*numFiltersPerType
               es_x = deconvlucy(y, h);
                subplot(3,2,6)
                imshow(es_x);
                title('Lucy');
        end
        
    psnrMax = 0;
    for ii = -3:3
        for jj = -3:3
            cropped = es_x(4+ii:end-3+ii,4+jj:end-3+jj);
            orig = x(4:end-3,4:end-3);
            cropped = cropped * (sum(orig(:)) / sum(cropped(:)));
            psnrCurr = psnr(cropped, orig);
            if (psnrCurr > psnrMax)
                psnrMax = psnrCurr;
            end
        end
    end
    %psnrCurr = psnr(es_x, img);
if psftye ==1
    psnrGauss(i,j+offset) = psnrMax;
else
    psnrDisk(i,j+offset) = psnrMax;
end

                savefig(['Figures/Im' num2str(imIdx) '_DiskFilt_' num2str(diskS) '.fig']);
            end
        end
    end
end

ppp(psnrGauss)
disp('')
disp('')
ppp(psnrDisk)