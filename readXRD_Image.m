function [image] = readXRD_Image(imPath,frame)

%Reads in .tif and binary files, as well as frames of GE2 and GE3 files
%Assumes 2048x2048 images, frame # optional argument

if(nargin < 2)
    frame = 1;
end

[PATHSTR,NAME,EXT] = fileparts(imPath);

if(strcmp(EXT,'.tif') || strcmp(EXT,'.tiff'))
    image = imread(fullfile(PATHSTR,[NAME,EXT]));
elseif(strcmp(EXT,'.bin') || strcmp(EXT,'.cor'))        
    d = dir(fullfile(PATHSTR,[NAME,EXT]));        
    if((d.bytes/(2048*2048)==2))
        ifs = fopen(fullfile(PATHSTR,[NAME,EXT]),'r','n');
        image=fread(ifs,[2048 2048],'*uint16');
        fclose(ifs);
    elseif((d.bytes/(2048*2048)==4))
        ifs = fopen(fullfile(PATHSTR,[NAME,EXT]),'r');
        image = fread(ifs,[2048,2048],'*int32');
        fclose(ifs);
    elseif((d.bytes/(2048*2048)==8))
        ifs = fopen(fullfile(PATHSTR,[NAME,EXT]),'r');
        image = fread(ifs,[2048,2048],'*float64');
        fclose(ifs);
    end
elseif(strcmp(EXT,'.ge2'))
    ifs = fopen(fullfile(PATHSTR,[NAME,EXT]),'r','n');
    fseek(ifs,8192+(frame-1)*2048*2048*2,'bof');
    image = fread(ifs,[2048 2048],'*uint16');
    fclose(ifs);
elseif(strcmp(EXT,'.ge3'))
    ifs = fopen(fullfile(PATHSTR,[NAME,EXT]),'r','n');
    fseek(ifs,8192+(frame-1)*2048*2048*4,'bof');
    image = fread(ifs,[2048 2048],'*int32');
    fclose(ifs);
else
    disp('Image format not supported, no image loaded.');
    image = zeros(2048,2048);
end
image = double(image);