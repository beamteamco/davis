function [fcount] = getGEnumFrames(imPath)

[PATHSTR,NAME,EXT] = fileparts(imPath);
d = dir(fullfile(PATHSTR,[NAME,EXT]));
fsize = d.bytes;

if(strcmp(EXT,'.ge2'))
    fcount = (fsize-8192)/(2048*2048*2);
elseif(strcmp(EXT,'.ge3'))
    fcount = (fsize-8192)/(2048*2048*4);
else
    fcount = -1;
end