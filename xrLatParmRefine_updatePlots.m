function [output1,varargout] = xrLatParmRefine_updatePlots(hObject, handles)
axes(handles.axes_plot)
if(handles.loaded == 1)
    if(get(handles.radiobutton_dspace,'Value')==1)
        plot(handles.axes_plot,handles.DATA_DSPACING,handles.DATA_INTENSITY,'Color',[.3,.6,.2]);
        title(handles.axes_plot,'Intensity vs d-spacing');
        ylabel(handles.axes_plot,'Intensity');
        xlabel(handles.axes_plot,'d-spacing (Å)');
        
        if(get(handles.checkbox_autoY,'Value')==1)
%             ylim(handles.axes_plot,'auto');           
%             set(handles.axes_plot,'YLimMode','auto');
            set(handles.axes_plot,'YLim',[min(handles.DATA_INTENSITY),1.1*max(handles.DATA_INTENSITY)])
        else
%             ylim(handles.axes_plot,[str2double(get(handles.edit_YMin,'String')),str2double(get(handles.edit_YMax,'String'))]);
            set(handles.axes_plot,'YLim',[str2double(get(handles.edit_YMin,'String')),str2double(get(handles.edit_YMax,'String'))]);
        end
        
        if(get(handles.checkbox_autoX,'Value')==1)
            xlim(handles.axes_plot,'auto');
        else
            xlim(handles.axes_plot,[str2double(get(handles.edit_XMin,'String')),str2double(get(handles.edit_XMax,'String'))]);
        end
        
        guidata(hObject,handles);
        handles = guidata(hObject);
        
        if(~isempty(handles.DATA_MAXES))
           hold on;
           plot(handles.axes_plot,handles.DATA_MAXES(:,1),handles.DATA_MAXES(:,2),'r*','markers',5);
           if(get(handles.checkbox_width,'Value')==1)
               for(i=1:size(handles.DATA_MAXES,1))
                   ys=get(handles.axes_plot,'YLim');
                   plot([handles.DATA_MAXES(i,1)-handles.DATA_MAXES(i,3)/2,...
                       handles.DATA_MAXES(i,1)+handles.DATA_MAXES(i,3)/2],...
                       [handles.DATA_MAXES(i,2),handles.DATA_MAXES(i,2)],'-r');
                   
                   plot([handles.DATA_MAXES(i,1)-handles.DATA_MAXES(i,3)/2,...
                       handles.DATA_MAXES(i,1)-handles.DATA_MAXES(i,3)/2],...
                       [ys(1),handles.DATA_MAXES(i,2)],':r');
                   plot([handles.DATA_MAXES(i,1)+handles.DATA_MAXES(i,3)/2,...
                       handles.DATA_MAXES(i,1)+handles.DATA_MAXES(i,3)/2],...
                       [ys(1),handles.DATA_MAXES(i,2)],':r');
               end
           end
           set(handles.axes_plot,'NextPlot','replacechildren');
        end
                

        if(get(handles.pushbutton_toolFndmax,'UserData')==1)
            hold on;
            disp(handles.gdlines(1,1))
            ys=get(handles.axes_plot,'YLim');
            plot(handles.axes_plot,[handles.gdlines(1,1),handles.gdlines(1,1)],ys,'r');

            set(handles.axes_plot,'NextPlot','replacechildren');
            set(handles.pushbutton_toolFndmax,'UserData',2);
        elseif(get(handles.pushbutton_toolFndmax,'UserData')==2)
            hold on
            ys=get(handles.axes_plot,'YLim');
            plot(handles.axes_plot,[handles.gdlines(1,1),handles.gdlines(1,1)],ys,'r');
            plot(handles.axes_plot,[handles.gdlines(2,1),handles.gdlines(2,1)],ys,'r');
            %MAX FINDING CODE HERE
            
            popval = get(handles.popupmenu_type,'Value');

            type = '';
            switch(popval)
                case(1)
                    type = 'cubic';
                case(2)
                    type = 'hexagonal';
                case(3)
                    type = 'trigonal';
                case(4)
                    type = 'tetragonal';
                case(5)
                    type = 'orthorhombic';
                case(6)    
                    type = 'monoclinic';
            end

            hkls = getHKLs(type);

            index = 1;
            indexx = 1;
            if(handles.gdlines(1,1) > handles.gdlines(2,1))
                temp1 = handles.gdlines(1,1);
                handles.gdlines(1,1)=handles.gdlines(2,1);
                handles.gdlines(2,1) = temp1;
            end
            for(i=1:length(handles.DATA_DSPACING))
                if(handles.DATA_DSPACING(i) > handles.gdlines(1,1) && handles.DATA_DSPACING(i) < handles.gdlines(2,1))
                    if(handles.DATA_INTENSITY(i) > handles.DATA_INTENSITY(index))
                        index = i;
                    end
                end                
            end
            for(k=1:length(handles.DATA_INITSPACING))
                if(abs(handles.DATA_DSPACING(index)-handles.DATA_INITSPACING(k))<abs(handles.DATA_DSPACING(index)-handles.DATA_INITSPACING(indexx)))
                    indexx = k;
                end                
            end
            output1 = [handles.DATA_DSPACING(index), handles.DATA_INTENSITY(index),0.25,handles.DATA_2THETA(index),str2double([num2str(hkls(1,indexx)),num2str(hkls(2,indexx)),num2str(hkls(3,indexx))]);];
            set(handles.axes_plot,'NextPlot','replacechildren');
            set(handles.pushbutton_toolFndmax,'BackgroundColor',[.92,.92,.92]);
            set(handles.pushbutton_toolFndmax,'UserData',0);
        end
        
        if(~isempty(handles.DATA_INITSPACING) && get(handles.checkbox_initspacing,'Value')==1)
           hold on;
           ys=get(handles.axes_plot,'YLim');
           disp(ys);
           for(i=1:length(handles.DATA_INITSPACING))
                plot(handles.axes_plot,[handles.DATA_INITSPACING(i),handles.DATA_INITSPACING(i)],ys,':b');
           end
%            disp(handles.DATA_INITSPACING);
%            disp(handles.ENERGY);
           set(handles.axes_plot,'NextPlot','replacechildren');
        end
        
        if(~isempty(handles.DATA_FIT) && get(handles.checkbox_fits,'Value')==1)
            hold on;
            for(i=1:length(handles.DATA_FIT))
                plot(handles.axes_plot,handles.DATA_FIT{i,1},handles.DATA_FIT{i,3},'.k');                
            end
            set(handles.axes_plot,'NextPlot','replacechildren');
        end
        
    else
        plot(handles.axes_plot,handles.DATA_2THETA,handles.DATA_INTENSITY,'Color',[.3,.6,.2]);
        title(handles.axes_plot,'Intensity vs 2\theta');
        ylabel(handles.axes_plot,'Intensity');
        xlabel(handles.axes_plot,'2\theta (°)');
        
        if(get(handles.checkbox_autoY,'Value')==1)
            ylim(handles.axes_plot,'auto');
        else
            ylim(handles.axes_plot,[str2double(get(handles.edit_YMin,'String')),str2double(get(handles.edit_YMax,'String'))]);
        end
        
        if(get(handles.checkbox_autoX,'Value')==1)
            xlim(handles.axes_plot,'auto');
        else
            xlim(handles.axes_plot,[str2double(get(handles.edit_XMin,'String')),str2double(get(handles.edit_XMax,'String'))]);
        end
    end
    
%     chil = get(handles.axes_plot,'Children');
%     for(i=1:length(chil))
%         set(chil(i),'ButtonDownFcn',{@lineCallback1,hObject,handles});
%     end
    
end