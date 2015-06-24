function [outValue1,outValue2,outValue3] = radialCompute(handles,inputImage,isLine,f_params,plots)

%f_params [angle, spread, radius, cX, cY, radiusL]
% [floor(r*cosd(angle+spread-90))+cX,floor(r*sind(angle+spread-90)+cY)];
% right spread angle
% inputImage = flip(inputImage); %random image chosen from sample data
h=6.626*10^-34;
c=3*10^8;
e=1.602*10^-19;
beamEnergy = str2double(get(handles.edit_energy,'String'));

pxLength = 10^(-6) * str2double(get(handles.edit_pixel,'String'));
dist = str2double(get(handles.edit_distance,'String'))/1000;
% disp(dist)
if(isLine == 1)
    %calculates 1d plot along radial line at specific theta
    dR = handles.dR;

    r=f_params(6):dR:f_params(3);
    output = zeros(1,length(r));
    theta2 = atan(r*pxLength/dist)*180/pi();
%     disp(theta2)
    lambda = h * c / ( 1000 * beamEnergy * e );
    d_spacing = lambda / 2 ./ sin((theta2*pi()/180) / 2) * 1e10;
    
    pxX = floor(r*cosd(f_params(1)))+f_params(4);
    pxY = floor(-r*sind(f_params(1)))+f_params(5);
    
    
%     disp(pxX)
%     disp(pxY)
    for(i=1:length(r))
        if(floor(pxX(i)) > 2048 || floor(pxX(i)) < 1 || floor(pxY(i)) > 2048 || floor(pxY(i)) < 1)
            output(i) = -1;
        else
            output(i) = inputImage(pxY(i),pxX(i));
        end
        
    end
    
    area = sum(dR.*output); %units = intensity*pixel
    
    msgbox(['Area under curve = ',num2str(area),' intensity*pixel'],'Calculation Information')

    if(get(handles.radiobutton_unitsTheta,'Value')==1)
        plot(handles.axes_spec,theta2,output)
        xlabel(handles.axes_spec,'2\theta (°)')
    else 
        plot(handles.axes_spec,d_spacing,output)
        xlabel(handles.axes_spec,'d-spacing (angstrom)')
    end
    
    title(handles.axes_spec,['1D Intensity Profile \theta= ',num2str(f_params(1)),'°'])
    
    
    ylabel(handles.axes_spec,'Intensity')
    
    set(handles.axes_spec,'Units','normalized');
    set(handles.axes_spec,'OuterPosition',[0,0,1,1]);
    handles.radial2d = handles.axes_spec;
    set(handles.axes_spec,'UserData',2);
%     figure
%     imagesc(output,[0,2000])
    outValue1 = output;
    outValue2 = theta2;
    outValue3 = d_spacing;
else
    %calculates 3d plot along radial radial slice
    dR = handles.dR;
    dTheta = handles.dTheta;
    
    r=f_params(6):dR:f_params(3)-dR ;
    thetas2 = atan(r*pxLength/dist)*180/pi();
    
    lambda = h * c / ( 1000 * beamEnergy * e );
    d_spacings = lambda / 2 ./ sin((thetas2*pi()/180) / 2) * 1e10;
%     d_spacings(d_spacings==Inf())=0;
%     disp(d_spacings)
    
    theta1 = f_params(1) - f_params(2);
    theta2 = f_params(1) + f_params(2);
    thetas = theta2:-dTheta:theta1;
    
%     disp(f_params(1)-90)
%     disp(theta2-theta1)    
    
%     for i =1:length(r)
%         for j=1:length(thetas)
%             pxX(i,j) = floor(r(i)*cosd(thetas(j))+f_params(4));
%             pxY(i,j) = floor(-r(i)*sind(thetas(j))+f_params(5));
%         end
%     end

%linear algebra method, much much faster
    pxX = floor(r'*cosd(thetas)+f_params(4));
    pxY = floor(-r'*sind(thetas)+f_params(5));
%     wb = waitbar(0,'Calculating...');
%     tot = length(r)*length(thetas);

    for(i=1:length(r))
        for(j=1:length(thetas))
            if(pxX(i,j) > 2048 || pxX(i,j) < 1 || pxY(i,j) > 2048 || pxY(i,j) < 1)
                tempOutput(i,j) = -1;
            else
                tempOutput(i,j) = inputImage(pxY(i,j),pxX(i,j));
%             output(i) = inputImage(floor(pxX(i)),floor(pxY(i)));
            end
%             waitbar(((j*(i-1))+j)/tot,wb);
        end
    end
    %^^ rows are increment in radius, column increments in (dtheta)
    
%     integral3d = tempOutput*thetas';
    integral3d = tempOutput*(dTheta.*ones(length(thetas),1));
    
    if(plots==1)
        if(get(handles.radiobutton_unitsTheta,'Value')==1)
            plot(handles.axes_spec,thetas2,integral3d);
            xlabel('2\theta (°)')
%             xlim('auto')
        else
            plot(handles.axes_spec,d_spacings,integral3d);
            xlabel('d-spacing (angstrom)')
%             xlim([0,20])
%             ylim('auto')
        end
        ylabel('Intensity^2');
        title(['1D Intensity Profile \theta= ',num2str(f_params(1)-f_params(2)),'° to ',num2str(f_params(1)+f_params(2)),'°'])
        set(handles.axes_spec,'Units','normalized');
        set(handles.axes_spec,'OuterPosition',[0,0,1,1]);
        handles.radial2d = handles.axes_spec;
        set(handles.axes_spec,'UserData',2);

        figure
        ttt=(f_params(1)-f_params(2)):dTheta:(f_params(1)+f_params(2));
        splot = surf(ttt,r,tempOutput)
        ylabel('Radius (pixels)');
        xlabel('Azimuth Angle (°)')
        zlabel('Intensity')
        title('3D Radial Unwrap')
        set(splot,'EdgeColor','none')
        colorbar
        ylabel(colorbar,'Intensity');

        figure
        imagesc(ttt,r,tempOutput,[handles.scale_spec_L handles.scale_spec_U])
        set(gca,'YDir','normal')
    %     plot(handles.axes_spec,r,output)
        title('2D Radial Unwrap')
        ylabel('Radius (pixels)')
        xlabel('Azimuth Angle (°)')
        colorbar;
        ylabel(colorbar,'Intensity');
    end
    
    outValue1 = integral3d;
    outValue2 = thetas2;
    outValue3 = d_spacings;
end
set(handles.button_calc,'UserData',0);
