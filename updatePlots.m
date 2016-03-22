function [output1,output2] = updatePlots(hObject,handles)

%L and R plots
output1 = {};
output2 = {};

if(handles.loaded == 1)
    if(get(handles.checkbox_subdark,'Value')==1)
        if(get(handles.checkbox_norm2,'Value')==1)
            axes(handles.axes_left);
%             tcountL = max(max(double(handles.images{str2double(get(handles.edit_indexL,'String'))+1}-handles.dark)));
    %         tcountL = 2000;
            imageL = (handles.images{str2double(get(handles.edit_indexL,'String'))+1}-handles.dark).*handles.normVals(str2double(get(handles.edit_indexL,'String'))+1);
            imagesc(imageL,[handles.scale_left_L, handles.scale_left_U]);
            colorbar;
            ylabel(colorbar,'Intensity');
            axis square
%             disp(sum(sum(double(handles.images{str2double(get(handles.edit_indexL,'String'))+1}-handles.dark))))

            axes(handles.axes_right);
            tcountR = max(max(double(handles.images{str2double(get(handles.edit_indexR,'String'))+1}-handles.dark)));
    %         tcountR = 2000;
            imageR = (handles.images{str2double(get(handles.edit_indexR,'String'))+1}-handles.dark).*handles.normVals(str2double(get(handles.edit_indexR,'String'))+1);
            imagesc(imageR,[handles.scale_right_L, handles.scale_right_U]);
            colorbar;
            ylabel(colorbar,'Intensity');
            axis square
        else
            axes(handles.axes_left);
            imageL = handles.images{str2double(get(handles.edit_indexL,'String'))+1}-handles.dark;
            imagesc(imageL,[handles.scale_left_L, handles.scale_left_U]);
            colorbar;
            ylabel(colorbar,'Intensity');
            axis square

            axes(handles.axes_right);
            imageR = handles.images{str2double(get(handles.edit_indexR,'String'))+1}-handles.dark;
            imagesc(imageR,[handles.scale_right_L, handles.scale_right_U]);
            colorbar;
            ylabel(colorbar,'Intensity');
            axis square
        end    
    else
        axes(handles.axes_left);
        imageL = handles.images{str2double(get(handles.edit_indexL,'String'))+1};
        imagesc(imageL,[handles.scale_left_L, handles.scale_left_U]);
        colorbar;
        ylabel(colorbar,'Intensity');
        axis square

        axes(handles.axes_right);
        imageR = handles.images{str2double(get(handles.edit_indexR,'String'))+1};
        imagesc(imageR,[handles.scale_right_L, handles.scale_right_U]);
        colorbar;
        ylabel(colorbar,'Intensity');
        axis square
    end

    %Spec plot

    if(get(handles.radiobutton_diff,'Value')==1)
        axes(handles.axes_spec);
        imagesc(imageR-imageL,[handles.scale_spec_L, handles.scale_spec_U]);
        setappdata(handles.axes_spec,'type',1);
        colorbar;
        ylabel(colorbar,'Intensity');
        axis square
    elseif(get(handles.radiobutton_summation,'Value')==1)
        disp('calculating sum')
        tic;
        
        summ = getSummedImage(handles);
        
        axes(handles.axes_spec);    
        imagesc(summ,[handles.scale_spec_L, handles.scale_spec_U]);
        setappdata(handles.axes_spec,'type',1);
        colorbar;
        ylabel(colorbar,'Intensity');
        axis square
        disp(['sum calculated, time elapsed= ',num2str(toc)])
    elseif(get(handles.radiobutton_radial,'Value')==1)
       
        axes(handles.axes_spec);
        if(get(handles.button_imcImage,'Value')==1)
            if(get(handles.checkbox_subdark2,'Value')==1)
                if(get(handles.checkbox_norm3,'Value')==1)
                    imagespec = (handles.images{str2double(get(handles.edit_radNum,'String'))+1}-handles.dark).*handles.normVals(str2double(get(handles.edit_radNum,'String'))+1);
                else
                    imagespec = handles.images{str2double(get(handles.edit_radNum,'String'))+1}-handles.dark;
                end
            else
                if(get(handles.checkbox_norm3,'Value')==1)
                    imagespec = handles.images{str2double(get(handles.edit_radNum,'String'))+1}.*handles.normVals(str2double(get(handles.edit_radNum,'String'))+1);
                else
                    imagespec = handles.images{str2double(get(handles.edit_radNum,'String'))+1};
                end
            end
        elseif(get(handles.button_imcDiff,'Value')==1)
            imagespec = imageR-imageL;
        elseif(get(handles.button_imcSum,'Value')==1)
            imagespec = getSummedImage(handles);
        elseif(get(handles.button_imcMaxOA,'Value')==1)
            if(get(handles.checkbox_subdark2,'Value')==1)
                imagespec = maxOverAllImages(handles.images) - handles.dark;
            else
                imagespec = maxOverAllImages(handles.images);
            end
            
        end

        setappdata(handles.axes_spec,'type',1);
        imagesc(imagespec,[handles.scale_spec_L, handles.scale_spec_U]);
        colorbar;
        ylabel(colorbar,'Intensity');
        axis square

        pxLength = 10^(-6) * str2double(get(handles.edit_pixel,'String'));
        dist = str2double(get(handles.edit_distance,'String'))/1000;

        if(get(handles.button_conv1,'UserData')==0)
            radiusU = str2double(get(handles.edit_radius,'String'));
            radiusL = str2double(get(handles.edit_radius2,'String'));
        elseif(get(handles.button_conv1,'UserData')==1)
            radiusU = tan(str2double(get(handles.edit_radius,'String'))/(180/pi()))/(pxLength/dist);
            radiusL = tan(str2double(get(handles.edit_radius2,'String'))/(180/pi()))/(pxLength/dist);
        end
        
        angle = str2double(get(handles.edit_angle,'String'));
        spread = str2double(get(handles.edit_spread,'String'));
        bins = str2double(get(handles.edit_bins,'String'));
        cX = str2double(get(handles.edit_x,'String'));
%         cY = str2double(get(handles.edit_y,'String'));
        cY = 2048 - str2double(get(handles.edit_y,'String'));

        %shows the radial options
        hold on
        tt=zeros(2048,2048);    
        r=radiusU;
        

        %center point
        p1 = [cX,cY];
        p5 = [cX,cY-40];
        p6 = [cX,cY+40];
        p7 = [cX-40,cY];
        p8 = [cX+40,cY];
        
        if(get(handles.checkbox_bins,'Value')==0)
            %angle bounds
            p2 = [r*cosd(angle+spread)+cX,-r*sind(angle+spread)+cY];
            p3 = [r*cosd(angle-spread)+cX,-r*sind(angle-spread)+cY];
            
            p22 = [radiusL*cosd(angle+spread)+cX,-radiusL*sind(angle+spread)+cY];
            p33 = [radiusL*cosd(angle-spread)+cX,-radiusL*sind(angle-spread)+cY];

            %center line
            p4 = [(r-.8*(r-radiusL))*cosd(angle)+cX,-(r-.8*(r-radiusL))*sind(angle)+cY];
            p9 = [(radiusL+.8*(r-radiusL))*cosd(angle)+cX,-(radiusL+.8*(r-radiusL))*sind(angle)+cY];

            % creates the arc guide
            angles = angle+spread:-0.1:angle-spread;
%             disp(angles)
            arcU =  [r*cosd(angles')+cX,-r*sind(angles')+cY];
            arcL = [radiusL*cosd(angles')+cX,-radiusL*sind(angles')+cY];
            
            %plots the guide lines
            plot([p22(1),p2(1)],[p22(2),p2(2)],'r')
            plot([p33(1),p3(1)],[p33(2),p3(2)],'r')
            plot([p9(1),p4(1)],[p9(2),p4(2)],'g')
            
            plot([p5(1),p6(1)],[p5(2),p6(2)],'y')
            plot([p7(1),p8(1)],[p7(2),p8(2)],'y')
            
            plot(arcU(:,1),arcU(:,2),'r')
            plot(arcL(:,1),arcL(:,2),'r')


            hold off
        else
            angleI = 360 / bins;
            angles = 0:.1:360;
            
            arcU =  [r*cosd(angles')+cX,-r*sind(angles')+cY];
            arcL = [radiusL*cosd(angles')+cX,-radiusL*sind(angles')+cY];
            
%             disp(radiusL)
            for(i=1:bins)
                %primary angles
                tempPoint = [(r-.8*(r-radiusL))*cosd(angleI*i + angle)+cX,-(r-.8*(r-radiusL))*sind(angleI*i+angle)+cY];
                tempPoint2 = [(radiusL+.8*(r-radiusL))*cosd(angleI*i+angle)+cX,-(radiusL+.8*(r-radiusL))*sind(angleI*i+angle)+cY];
                
                %angle guides
                p4 = [r*cosd(angleI*i+angleI/2+angle)+cX,-r*sind(angleI*i+angleI/2+angle)+cY];
                p9 = [radiusL*cosd(angleI*i+angleI/2+angle)+cX,-radiusL*sind(angleI*i+angleI/2+angle)+cY];
            
                plot([tempPoint2(1),tempPoint(1)],[tempPoint2(2),tempPoint(2)],'g')
                plot([p9(1),p4(1)],[p9(2),p4(2)],'r')
            end
            plot([p5(1),p6(1)],[p5(2),p6(2)],'y')
            plot([p7(1),p8(1)],[p7(2),p8(2)],'y')
            
            plot(arcU(:,1),arcU(:,2),'r')
            plot(arcL(:,1),arcL(:,2),'r')
            
            hold off
        end

        params = [angle, spread, radiusU, cX, cY, radiusL];
        
        if(spread == 0 && get(handles.button_calc,'UserData')==1)
            set(handles.checkbox_vout,'Value',1);
            radialCompute(handles,imagespec,1,params,1)
            setappdata(handles.axes_spec,'type',2);
        elseif(spread ~= 0 && get(handles.button_calc,'UserData')==1)
            set(handles.checkbox_vout,'Value',1);            
            setappdata(handles.axes_spec,'type',3);
            binData = {};
            if(get(handles.checkbox_bins,'Value')==1)
%                 handles.resolutionW = str2double(x{1});
            %     handles.resolutionH = str2double(x{2});
            %     handles.vidFormat = x{3};
            %     handles.vidFramerate = str2double(x{4});
    
                if(strcmp(get(handles.menu_binvid,'Checked'),'on'))
                    if(strcmp(handles.vidFormat,'.avi'))
                        format = 'Uncompressed AVI';
                    elseif(strcmp(handles.vidFormat,'.mp4'))
                        format = 'MPEG-4';
                    end
                    
                    if(isempty(handles.binDir))
                        tempFilename = [handles.binStem,'VIDEO',handles.vidFormat];
                    else
                        tempFilename = [handles.binDir,'/',handles.binStem,'VIDEO',handles.vidFormat];
                    end
                    outputVideo = VideoWriter(tempFilename,format);
                    outputVideo.FrameRate = handles.vidFramerate;
                    open(outputVideo)
                end
                handles.binImages = {};
                
                for(i=0:bins-1)
                    sp2 = 360/bins;
                    params = [angle+sp2*i, sp2/2, radiusU, cX, cY, radiusL];
                    [im,thetas,d_spacing] = radialCompute(handles,imagespec,0,params,0);
                    disp(['Bin #',num2str(i+1),' completed'])
                    
%                     binFig = figure('visible','off');
                    
%                     set(binFig,'Position',[0,0,1200,900])
                    if(~isempty(handles.binDir))
                        filename = [handles.binDir,'/',handles.binStem,num2str(i,'%03.0f'),handles.binExten];
                    else
                        filename = [handles.binDir,handles.binStem,num2str(i,'%03.0f'),handles.binExten];
                    end
                    
                    
                    if(get(handles.radiobutton_unitsTheta,'Value')==1)
                        plot(thetas,im)     
                        xlabel('2\theta (°)')
                        output1{i+1} = [im,thetas'];
                        output2(i+1,:) = {'2\theta (°)','Intensity^2',['1D Intensity Profile \theta= ',num2str(angle+sp2*i-sp2/2),'° to ',num2str(angle+sp2*i+sp2/2),'°']};
                    else
                        plot(d_spacing,im)     
                        xlabel('d-spacing (angstroms)')
                        output1{i+1} = [im,d_spacing'];
                        output2(i+1,:) = {'d-spacing (angstrom)','Intensity^2',['1D Intensity Profile \theta= ',num2str(angle+sp2*i-sp2/2),'° to ',num2str(angle+sp2*i+sp2/2),'°']};
                    end
                    
%                     ylabel('Intensity^2');
%                     title(['1D Intensity Profile \theta= ',num2str(angle+sp2*i-sp2/2),'° to ',num2str(angle+sp2*i+sp2/2),'°'])
%                     saveas(binFig,filename);  
                    
                    binData = [binData,[{[num2str(angle+sp2*i-sp2/2),'° to ',num2str(angle+sp2*i+sp2/2),'°','intensity'],'2theta ','d-spacing'};num2cell(im),num2cell(thetas'),num2cell(d_spacing');...
                        {'beam energy','',''};...
                    num2cell(str2double(get(handles.edit_energy,'String'))),{'',''}]];
%                     title('');
%                     ylim([0 120000])
%                     writeVideo(outputVideo,getframe(binFig));
                end
                
                set(handles.button_binPlus,'Enable','on');
                set(handles.button_binMinus,'Enable','on');
                
                if(strcmp(get(handles.menu_binvid,'Checked'),'on'))
                    close(outputVideo);
                    disp('Done Creating Video')
                end
%                 disp(output1);
                
                tMatrix = output1{1};
                plot(handles.axes_spec,tMatrix(:,2),tMatrix(:,1));
                xlabel(handles.axes_spec,output2{1,1})
                ylabel(handles.axes_spec,output2{1,2})
                title(handles.axes_spec,output2{1,3})
                set(handles.text_bnumber,'String','Bin #1');
%                 output1 = handles.binIndex;
%                 avi = VideoReader('testvid.avi');   
                
            else
                [im, thetas,d_spacing] = radialCompute(handles,imagespec,0,params,1);
                binData = [{'intensity','thetas','d-spacing'};num2cell(im),num2cell(thetas'),num2cell(d_spacing');...
                    {'beam energy','',''};...
                    num2cell(str2double(get(handles.edit_energy,'String'))),{'',''}];
            end
            %INSERT CODE FOR SAVING BIN MAT HERE
            if(isempty(handles.binDir))
                tempFilename = [handles.binStem,'DATA.mat'];
            else
                tempFilename = [handles.binDir,'/',handles.binStem,'DATA.mat'];
            end
            
            save(tempFilename,'binData');
        end            
%         disp(get(handles.axes_spec,'UserData'))

%         disp(handles.binIndex)
        if(get(handles.button_binMinus,'UserData')==1)    
            if(~isempty(handles.binImages))
                if(handles.binIndex > 1)
                    tMatrix = handles.binImages{handles.binIndex-1};
                    plot(handles.axes_spec,tMatrix(:,2),tMatrix(:,1));
                    output1 = handles.binIndex-1;
%                     disp(['bin index=',num2str(handles.binIndex)])
%                     disp(handles.binIndex)                    
                    xlabel(handles.binLabels{handles.binIndex-1,1})
                    ylabel(handles.binLabels{handles.binIndex-1,2})
                    title(handles.binLabels{handles.binIndex-1,3})
                    set(handles.text_bnumber,'String',['Bin #',num2str(handles.binIndex-1)]);
                else
                    tMatrix = handles.binImages{handles.binIndex};
                    plot(handles.axes_spec,tMatrix(:,2),tMatrix(:,1));
                    output1 = handles.binIndex;
                    xlabel(handles.binLabels{handles.binIndex,1})
                    ylabel(handles.binLabels{handles.binIndex,2})
                    title(handles.binLabels{handles.binIndex,3})
                    set(handles.text_bnumber,'String',['Bin #',num2str(handles.binIndex)]);
                end
            end
            set(handles.button_binMinus,'UserData',0)
        end
        if(get(handles.button_binPlus,'UserData')==1)
            if(~isempty(handles.binImages))
                if(handles.binIndex < size(handles.binImages,2))
                    tMatrix = handles.binImages{handles.binIndex+1};
%                     disp(tMatrix)
                    plot(handles.axes_spec,tMatrix(:,2),tMatrix(:,1));
                    output1 = handles.binIndex+1;
%                     disp(['bin index=',num2str(handles.binIndex)])
                    xlabel(handles.binLabels{handles.binIndex+1,1})
                    ylabel(handles.binLabels{handles.binIndex+1,2})
                    title(handles.binLabels{handles.binIndex+1,3})
                    set(handles.text_bnumber,'String',['Bin #',num2str(handles.binIndex+1)]);
                else
                    tMatrix = handles.binImages{handles.binIndex};
                    plot(handles.axes_spec,tMatrix(:,2),tMatrix(:,1));
                    output1 = handles.binIndex;
                    xlabel(handles.binLabels{handles.binIndex,1})
                    ylabel(handles.binLabels{handles.binIndex,2})
                    title(handles.binLabels{handles.binIndex,3})
                    set(handles.text_bnumber,'String',['Bin #',num2str(handles.binIndex)]);
                end
            end
            set(handles.button_binPlus,'UserData',0)
        end
end

    title(handles.axes_left,['Image # ',get(handles.edit_indexL,'String')]);
    title(handles.axes_right,['Image # ',get(handles.edit_indexR,'String')]);

    % xlabel(handles.axes_leAt,'Pixel');
    % ylabel(handles.axes_left,'Pixel');
    % xlabel(handles.axes_right,'Pixel');
    % ylabel(handles.axes_right,'Pixel');

end