%%% Ge3 tp Ge2 converter
%%% Author: Andrew Petersen

%DESCRIPTION: Loads the int32 xrd data from a ge3 file and resaves as uint16 (NOTE: header should be
%preremoved). There is a loss of intensity resolution when converting.
%
%USAGE: Run the script, you will be prompted to select the ge3 files. Do so
%by selecting as many as needed and press open. After data is loaded, you
%are prompted for a output file directory. Once chosen, the script will
%save the fales with their original names, with the extension ".uint16" at
%the end to indentify them

[t1,t2] = uigetfile('*.*','Select GE3 Files','Multiselect','On');

if(~ischar(t1) && ~iscell(t1))
    return
end

len = 1;
if(iscell(t1))
    len = size(t1,2);
end

im = cell(len,1);
wb = waitbar(0,'Loading XRD Data');
for(i=1:len)
    fi = fopen(fullfile(t2,t1{i}));
    im{i} = uint16(double(fread(fi,[2048 2048],'*int32'))*2^16/2^32);
    fclose(fi);
    waitbar(i/len,wb,'Loading XRD Data');
end
close(wb);

[s1] = uigetdir();

if(~ischar(s1))
    return
end

wb = waitbar(0,'Saving XRD Data');
for(i=1:len)
    fo = fopen(fullfile(s1,[t1{i},'.uint16']),'w');
    fwrite(fo,im{i},'uint16');
    fclose(fo);
    waitbar(i/len,wb,'Saving XRD Data');
end
close(wb);