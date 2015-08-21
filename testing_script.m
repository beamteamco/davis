
try
    close all
    clear all
end

tiltPlane = -28.0315;
inPlane   = -0.4975;
inPlane   = -35;
cx = 1025.289;
cy = 1024.1225;


% testImage = ReadInGE('C:\Users\Andy Petersen\Documents\MATLAB\Xray\2013_12_NiTi1Hf\Sample6_5_00006.tiff'); % lab comp
testImage = double(imread('C:\Users\Andy\Documents\2013_12_NiTi1Hf\Sample6_5_00006.tiff','tiff')); %home comp

outputImage = TiltPlaneCorrection(testImage,tiltPlane,inPlane,cx,cy);


figure

subplot(1,2,1);
imagesc(testImage,[0,max(max(testImage))]);
xlabel('Columns');
ylabel('Rows');
axis square

subplot(1,2,2);
imagesc(outputImage,[0,max(max(testImage))]);
xlabel('Columns');
ylabel('Rows');
axis square