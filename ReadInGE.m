%function [image] = ReadInGE(file)
% Written by Darren Pagan
% Updated by Mark Obstalecki to be 20% FASTER!!!!
function [image] = ReadInGE(file)
fp = fopen(file,'r','n');
image=double(fread(fp,[2048 2048],'*uint16'));
fclose(fp);
% image=flipdim(image,1);
% image=imrotate(image,90);
% 
% image=flipdim(image,1);
% image=flipdim(image',1);