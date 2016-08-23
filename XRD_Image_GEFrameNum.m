function [fcount] = XRD_Image_GEFrameNum(imPath)

[PATHSTR,NAME,EXT] = fileparts(imPath);
d = dir(fullfile(PATHSTR,[NAME,EXT]));
fsize = d.bytes;

if(strcmp(EXT,'.ge2'))
    fcount = (fsize-8192)/(2048*2048*2);
    if(mod(fsize-8192,2048*2048*2)~=0)
        fcount = -1;
    end
elseif(strcmp(EXT,'.ge3'))
    fcount = (fsize-8192)/(2048*2048*2);
    if(mod(fsize-8192,2048*2048*2)~=0)
        fcount = -1;
    end
elseif(strcmp(EXT,'.tif') || strcmp(EXT,'.tiff'))
    fcount = 1;
else
    fcount = -1;
end