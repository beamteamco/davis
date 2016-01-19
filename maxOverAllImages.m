function output = maxOverAllImages(images)

n = length(images);
temp = zeros(2048,2048);

for(i=1:n-1)
    if(i == 1)
        temp = floor(images{i+1}./images{i}).*images{i+1} + (floor(images{i+1}./images{i})*-1 + 1).*images{i};
    else
        temp = floor(images{i+1}./temp).*images{i+1} + (floor(images{i+1}./temp)*-1 + 1).*temp;
    end    
end

output = temp;