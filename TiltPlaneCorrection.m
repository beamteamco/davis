function outputImage = TiltPlaneCorrection(im,tiltPlaneAngle,detectortTiltPlaneAngle,cx,cy)
tic;
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

%stores the vectors for the corrected image plane pixels (integer values)
pixelVectors = zeros(3,imRows*imCols);

%assigns coordinates to the pixel vectors
for(i=1:imRows)
    for(j=1:imCols)
         pixelVectors(:,imRows*(i-1)+j) = [j-cx;-i+(imRows-cy);0];
    end
end

%rotates the pixel vectors, converts the vector coordinates to pixel space coordinates (-y up, +x
%right, adjusting for image center x and y)
pixelVectors_rotated = ((R*pixelVectors).*([1;-1;1]*ones(1,size(pixelVectors,2)))) + ([cx;cy;0]*ones(1,size(pixelVectors,2)));

outputImage = zeros(imRows,imCols);

tics = 0;

interpedValues = zeros(1,imRows*imCols);
interpedValues = interp2(im,pixelVectors_rotated(1,:),pixelVectors_rotated(2,:));

disp(sprintf('\tInterpolation Complete'));

for(i=1:imRows)
    for(j=1:imCols)
        tics = imRows*(i-1)+j;
        col = pixelVectors_rotated(1,tics);
        row = pixelVectors_rotated(2,tics);
        
        if(col <= imCols && col >= 1 && row <= imRows && row >= 1)
            outputImage(i,j) = interpedValues(tics);
        end
    end
end

% delete h;

% for(i=1:imRows)
%     for(j=1:imCols)        
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CEIL METHOD%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         %Utilises ceil method (floor would work as well), will be imprecise for rotation angles larger than 60
%         %degrees (acos(0.5)=60 degrees). This causes an overite of values and an
%         %interpolation or similar method is necesary to correct that
%         
%         cvalR = ceil(pixelVectors_rotated(2,imRows*(i-1)+j));
%         cvalC = ceil(pixelVectors_rotated(1,imRows*(i-1)+j));
%         
%         if(cvalC > 0 && cvalC < imCols+1 &&...
%                 cvalR > 0 && cvalR < imRows+1)
%             outputImage(cvalR,cvalC) = pixelVectors_rotated(4,imRows*(i-1)+j);
%         end
%    
%     end
% end
disp(sprintf('\tCorrection Elapsed Time = %5.3f',toc));