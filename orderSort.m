function [output] = orderSort(A,type, col)

output = A;
if(type=='a')
    for(i=1:size(A,1))
        index = i;
        for(j=i:size(A,1))
            if(A(j,col) < A(index,col))
                index = j;
            end
        end
        output(i,:) = A(index,:);
        A(index,:) = A(i,:);
    end
elseif(type=='d')
    for(i=1:size(A,1))
        index = 1;
        for(j=i:size(A,1))
            if(A(j,col) > A(index,col))
                index = j;
            end
        end
        output(i,:) = A(index,:);
        A(index,:) = A(i,:);
    end
else
    disp('Type not recognized, a=ascending, d=descending');
end