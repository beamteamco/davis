function outputImage = TiltPlaneCorrection(im,tiltPlaneAngle,detectortTiltPlaneAngle,cx,cy)

im = double(im);

imRows = size(im,1);
imCols = size(im,2);


% % %Implememtation uses Rodruiges Rotation Formula

%rotation axes unit vector (using fit2d convention for definition)
w = [cosd(90+tiltPlaneAngle);
    sind(90+tiltPlaneAngle);
    0];

w_  =    [  0   -w(3)   w(2);
            w(3)    0   -w(1);
            -w(2)   w(1)    0];
        
I = [1 0 0;
    0 1 0;
    0 0 1];

R = I + sind(detectortTiltPlaneAngle)*w_ + (1-cosd(detectortTiltPlaneAngle))*(w_)^2;
Rz = I + sind(-detectortTiltPlaneAngle)*w_ + (1-cosd(-detectortTiltPlaneAngle))*(w_)^2;

pixelVectors = zeros(4,imRows*imCols);
zVals = zeros(3,imRows*imCols);

for(i=1:imRows)
    for(j=1:imCols)
         pixelVectors(:,2048*(i-1)+j) = [j-cx;-i+(imRows-cy);0;im(i,j)];
         zVals(:,2048*(i-1)+j) = [j-cx;-i+(imRows-cy);0];
    end
end

%converts the vector coordinates to pixel space coordinates (-y up, +x
%right, asjusting for image center x and y)
zVals_rotated = ((Rz*zVals).*([1;-1;1]*ones(1,size(zVals,2)))) + ([cx;cy;0]*ones(1,size(zVals,2)));

pixelVectors(3,:) = zVals_rotated(3,:);
pixelVectors_rotated = ((R*pixelVectors(1:3,:)).*([1;-1;1]*ones(1,size(pixelVectors,2)))) + ([cx;cy;0]*ones(1,size(pixelVectors,2)));

%adds in each vectors coresponding intensity value to the matrix
pixelVectors_rotated = [pixelVectors_rotated;pixelVectors(4,:)];

outputImage = zeros(imRows,imCols); %using NaN for ease of missing value checking
for(i=1:imRows)
    for(j=1:imCols)
        
        %utilises ceil method (floor would work as well), will be imprecise for rotation angles larger than 60
        %degrees (acos(0.5)=60 degrees). This causes an overite of values and an
        %interpolation or similar method is necesary to correct that
        
        if(ceil(pixelVectors_rotated(1,2048*(i-1)+j)) > 0 && ceil(pixelVectors_rotated(1,2048*(i-1)+j)) < imCols+1 &&...
                ceil(pixelVectors_rotated(2,2048*(i-1)+j)) > 0 && ceil(pixelVectors_rotated(2,2048*(i-1)+j)) < imRows+1)
            outputImage(ceil(pixelVectors_rotated(2,2048*(i-1)+j)),ceil(pixelVectors_rotated(1,2048*(i-1)+j))) = pixelVectors_rotated(4,2048*(i-1)+j);
        end
    end
end