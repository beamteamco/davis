function [image] = getSummedImage(handles)
ct=1;
for(i=1:handles.count)
    if(get(handles.checkbox_subdark2,'Value')==1)
        if(get(handles.checkbox_norm3,'Value')==1)
            if(isempty(find(handles.darkNum==i-1)))
                if(ct==1)
                    summ = (handles.images{i}-handles.dark).*handles.normVals(i);
                    ct=ct+1;
                else
                    summ = summ + (handles.images{i}-handles.dark).*handles.normVals(i);
                    ct=ct+1;
                end
            end
        else
            if(isempty(find(handles.darkNum==i-1)))
                if(ct==1)
                    summ = handles.images{i}-handles.dark;
                    ct=ct+1;
                else
                    summ = summ + (handles.images{i}-handles.dark);
                    ct=ct+1;
                end
            end
        end
    else
        if(get(handles.checkbox_norm3,'Value')==1)
            if(isempty(find(handles.darkNum==i-1)))
                if(ct==1)
                    summ = (handles.images{i}).*handles.normVals(i);
                    ct=ct+1;
                else
                    summ = summ +(handles.images{i}).*handles.normVals(i);
                    ct=ct+1;
                end
            end
        else
            if(isempty(find(handles.darkNum==i-1)))
                if(ct==1)
                    summ = (handles.images{i});
                    ct=ct+1;
                else
                    summ = summ + (handles.images{i});
                    ct=ct+1;
                end
            end
        end
    end        
end

%         disp(ct-1)
if(get(handles.checkbox_average,'Value')==1)
    summ = summ./(ct-1);
end

image = summ;