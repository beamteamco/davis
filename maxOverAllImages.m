function output = maxOverAllImages(images)

n = length(images);
temp = zeros(2048,2048);

h = waitbar(0,'Computing Max Over All Images');
for(i=1:n-1)
    if(i == 1)
        k = floor(images{i+1}./images{i});
        k = k./k;
        k(isnan(k))=0;
        temp = k.*images{i+1} + (k*-1 + 1).*images{i};
    else
        k = floor(images{i+1}./temp);
        k = k./k;
        k(isnan(k))=0;
        temp = k.*images{i+1} + (k*-1 + 1).*temp;
    end  
    waitbar(i/(n-1),h,'Computing Max Over All Images');
end
close(h);
output = temp;