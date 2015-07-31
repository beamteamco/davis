
tilt = -28.6;
cx = 1024;
cy = 1024;

% Rx =    [1,     0,               0,...
%         0,      cosd(tilt),    -sind(theta),...
%         0,      sind(tilt),    cosd(theta)];
        
    
testImage = ReadInGE('C:\Users\Andy Petersen\Documents\MATLAB\Xray\2013_12_NiTi1Hf\Sample6_5_00006.tiff');

figure
imagesc(testImage,[0,max(max(testImage))]);

%tilt only

%j=x index;
%i = y index;

newIm = zeros(4096,4096);

for(i=1:size(testImage,2))
    for(j=1:size(testImage,1))
        nx = j-cx;
        ny = (cy-i)/sind(90+tilt);
        
        npx = nx+cx;
        npy = ny+1024;
        newIm(ceil(npx)+1024,ceil(npy)+1024) = testImage(i,j);
    end
end

imagesc(newIm,[0,max(max(newIm))]);