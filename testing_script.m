
try
    close all
    clear all
end

tiltPlane = -28.0315;
inPlane   = -0.4975;
inPlane   = -35;
cx = 1024;
cy = 1024;

% Rx =    [1,     0,               0;...
%          0,      cosd(tilt),    -sind(tilt);...
%          0,      sind(tilt),    cosd(tilt)];
   
%Uses rodruiges rotation formula

%rotation axes unit vector (using fit2d convention for definition)
w = [cosd(90+tiltPlane);
    sind(90+tiltPlane);
    0];

w_  =    [  0   -w(3)   w(2);
            w(3)    0   -w(1);
            -w(2)   w(1)    0];
        
I = [1 0 0;
    0 1 0;
    0 0 1];

R = I + sind(-inPlane)*w_ + (1-cosd(-inPlane))*(w_)^2;


% % % testThetas = 0:5:360;
% % % R_test = zeros(3,3,length(testThetas));
% % % 
% % % for(i=1:length(testThetas))
% % %     R_test(:,:,i) = I + sind(testThetas(i))*w_ + (1-cosd(testThetas(i)))*(w_)^2;
% % % end
% % % 


% % 
% % x = [1;0;0];
% % 
% % % x_test = zeros(3,1,length(testThetas));
% % % 
% % % for(i=1:size(x_test,3))
% % %     x_test(:,:,i) = R_test(:,:,i)*x;
% % %     if(i==1)
% % %         disp(R_test(:,:,i));
% % %         disp(x);
% % %         disp(R_test(:,:,i)*x);
% % %     end
% % % end
% % 
% % x2 = R*x;
% % 
% % figure        
% % quiver3(0,0,0, w(1),w(2),w(3),'r');
% % hold on
% % quiver3(0,0,0, x(1),x(2),x(3),'b');
% % quiver3(0,0,0, x2(1),x2(2),x2(3),'g');
% % 
% % xlim([-1,1]);
% % ylim([-1,1]);
% % zlim([-1,1]);

% testImage = ReadInGE('C:\Users\Andy Petersen\Documents\MATLAB\Xray\2013_12_NiTi1Hf\Sample6_5_00006.tiff'); % lab comp
testImage =double(imread('C:\Users\Andy\Documents\2013_12_NiTi1Hf\Sample6_5_00006.tiff','tiff')); %home comp

pixelVectors = zeros(4,2048*2048);

for(i=1:2048)
    for(j=1:2048)
         pixelVectors(:,2048*(i-1)+j) = [j-cx;-i+cy;0;testImage(i,j)];
    end
end

%converts the vector coordinates to pixel space coordinates (-y up, +x
%right, asjusting for image center x and y)
pixelVectors_rotated = ((R*pixelVectors(1:3,:)).*([1;-1;1]*ones(1,size(pixelVectors,2)))) + ([cx;cy;0]*ones(1,size(pixelVectors,2)));

%adds in each vectors coresponding intensity value to the matrix
pixelVectors_rotated = [pixelVectors_rotated;pixelVectors(4,:)];

newIM = ones(2048,2048)*NaN; %using NaN for ease of missing value checking

for(i=1:2048)
    for(j=1:2048)        
%         for(k=1:size(pixelVectors_rotated,2))                        
%             if(sqrt(pixelVectors_rotated(1,k).^2+pixelVectors_rotated(2,k).^2) < ...
%                     sqrt(pixelVectors_rotated(1,index).^2+pixelVectors_rotated(2,index).^2))
%                 index((2048*(i-1)+ j))=k;
%             end
%         end

%utilises ceil method (floor would work as well), will be imprecise for rotation angles larger than 60
%degrees (acos(0.5)=60 degrees). This causes an overrite of values and an
%interpolation method is necesary to accommidate for that
        if(ceil(pixelVectors_rotated(1,2048*(i-1)+j)) > 0 && ceil(pixelVectors_rotated(1,2048*(i-1)+j)) < 2049 &&...
                ceil(pixelVectors_rotated(2,2048*(i-1)+j)) > 0 && ceil(pixelVectors_rotated(2,2048*(i-1)+j)) < 2049)
            newIM(ceil(pixelVectors_rotated(2,2048*(i-1)+j)),ceil(pixelVectors_rotated(1,2048*(i-1)+j))) = pixelVectors_rotated(4,2048*(i-1)+j);
        end
    end
end
disp('done')

figure
imagesc(testImage,[0,max(max(testImage))]);  
title('Original');
axis square

figure
imagesc(newIM,[0,max(max(testImage))]);  
title('Adjusted');
axis square



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
% % % newIm = zeros(4096,4096);
% % % c=sind(90+tilt);
% % % for(i=1:size(testImage,2))
% % %     for(j=1:size(testImage,1))
% % %         ny = (cy-j)/c;        
% % %         npy = -(ny-1024);
% % %         newIm(ceil(npy)+1024,i+1024) = testImage(j,i); %note 1024 in here is padding
% % %     end
% % % end
% % % 
% % % figure
% % % imagesc(newIm,[0,max(max(newIm))]);
% % % axis square
% % % disp('done')

% % th = 4.7032;
% % eta = 0:360/72:360-360/72;
% % ome = -62.5:5:62.5;
% % 
% % try
% %     close(h)
% % end
% % 
% % h = figure;
% % 
% % origin = [0,0,0];
% % x = [5,0,0];
% % y = [0,5,0];
% % z = [0,0,5];
% % 
% % pl = plot3([origin(1),x(1)],[origin(2),x(2)],[origin(3),x(3)],'r');
% % xlim([-2,2]);
% % ylim([-2,2]);
% % zlim([-2,2]);
% % grid on
% % hold on
% % plot3([origin(1),y(1)],[origin(2),y(2)],[origin(3),y(3)],'g');
% % plot3([origin(1),z(1)],[origin(2),z(2)],[origin(3),z(3)],'b');
% % 
% % 
% % eta = eta + 180;
% % 
% % q0  = [1 0 0]';
% % 
% % %y-axis rotation
% % R_th    = [ ...
% %     cosd(th) 0 sind(th); ...
% %     0 1 0; ...
% %     -sind(th) 0 cosd(th); ...
% %     ];
% % q0  = R_th*q0;
% % 
% % plot3([origin(1),q0(1)],[origin(2),q0(2)],[origin(3),q0(3)],'k');
% % 
% % n_ome   = length(ome);
% % n_eta   = length(eta);
% % 
% % q_eta   = zeros(3,n_eta);
% % for i = 1:1:n_eta
% %     %z-axis rotation
% %     R_eta   = [ ...
% %         cosd(eta(i)) -sind(eta(i)) 0; ...
% %         sind(eta(i)) cosd(eta(i)) 0; ...
% %         0 0 1; ...
% %         ]';
% %     temp = R_eta*q0;
% %     q_eta(:,i)  = temp;
% %     plot3([origin(1),temp(1)],[origin(2),temp(2)],[origin(3),temp(3)],'k');
% % end
% % 
% % q_pf    = zeros(3,n_eta * n_ome);
% % for i = 1:1:n_ome
% %     %y-axis rotation
% %     R_ome   = [ ...
% %         cosd(ome(i)) 0 sind(ome(i)); ...
% %         0 1 0; ...
% %         -sind(ome(i)) 0 cosd(ome(i)); ...
% %         ];
% %     temp = R_ome*q_eta;
% %     q_ome	= temp;
% %     
% %     if(i==1)
% %         assignin('base','set1',temp);
% %     end
% %     if(i==2)
% %         assignin('base','set2',temp);
% %     end
% %     plot3([origin(1),temp(1)],[origin(2),temp(2)],[origin(3),temp(3)],'k');
% %     
% %     ini = 1 + n_eta * (i - 1);
% %     fin = n_eta * i;
% %     q_pf(:,ini:fin)  = q_ome;
% % end
% % 
% % plot3(set1(1,:),set1(2,:),set1(3,:))
% % plot3(set2(1,:),set2(2,:),set2(3,:))