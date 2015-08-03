
tilt = -28.6;
cx = 1024;
cy = 1024;

 Rx =    [1,     0,               0;...
         0,      cosd(tilt),    -sind(tilt);...
         0,      sind(tilt),    cosd(tilt)];
        
    
testImage = ReadInGE('C:\Users\Andy Petersen\Documents\MATLAB\Xray\2013_12_NiTi1Hf\Sample6_5_00006.tiff');

figure
imagesc(testImage,[0,max(max(testImage))]);

%tilt only



% imVectors = zeros(2048*2048,3);
% c=tand(90+tilt);
% 
% figure
% % quiver3(0,0,0,0,0,0);
% % hold on;
% for(i=1:2048)
%     for(j=1:2048)
%         imVectors((i-1)*2048 + j,:) = [j-1024,-i+1024,(-i+1024)/c];       
% %         quiver3(0,0,0,imVectors(i-1+1024));
%     end
% end
% 
% xx=reshape(imVectors,2048,2048,3);
% figure
% mesh(xx(:,:,3));
% 
% imVectors2 = (Rx*imVectors')';
% xx2=reshape(imVectors2,2048,2048,3);
% figure
% mesh(xx2(:,:,3));
newIm = zeros(4096,4096);
c=sind(90+tilt);
for(i=1:size(testImage,2))
    for(j=1:size(testImage,1))
        ny = (cy-j)/c;        
        npy = -(ny-1024);
        im
        newIm(ceil(npy),i) = testImage(j,i); %note 1024 in here is padding
    end
end

figure
imagesc(newIm,[0,max(max(newIm))]);

disp('done')