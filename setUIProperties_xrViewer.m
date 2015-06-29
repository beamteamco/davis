function setUIProperties_xrViewer(hObject,handles)
%% 
%UI property setting function used for possible solution in cross-platform
%compatibility. Also provides easy way to change global app parameters such
%as  font type, size etc. (position needs to be manually adjusted)

%for reference
%http://www.mathworks.com/help/matlab/creating_guis/designing-for-cross-platform-compatibility.html
%%
%All generic text labels
set(handles.text1,'Units','normalized');
set(handles.text1,'FontUnits','normalized');
set(handles.text2,'FontName','Arial');

set(handles.text2,'Units','normalized');
set(handles.text2,'FontUnits','normalized');
set(handles.text2,'FontName','Arial');

set(handles.text3,'Units','normalized');
set(handles.text3,'FontUnits','normalized');
set(handles.text3,'FontName','Arial');

set(handles.text4,'Units','normalized');
set(handles.text4,'FontUnits','normalized');
set(handles.text4,'FontName','Arial');

set(handles.text5,'Units','normalized');
set(handles.text5,'FontUnits','normalized');
set(handles.text5,'FontName','Arial');

% set(handles.text6,'Units','normalized');
% set(handles.text6,'FontUnits','normalized');
% set(handles.text6,'FontName','Arial');
% 
% set(handles.text7,'Units','normalized');
% set(handles.text7,'FontUnits','normalized');
% set(handles.text7,'FontName','Arial');

set(handles.text8,'Units','normalized');
set(handles.text8,'FontUnits','normalized');
set(handles.text8,'FontName','Arial');

set(handles.text9,'Units','normalized');
set(handles.text9,'FontUnits','normalized');
set(handles.text9,'FontName','Arial');

set(handles.text10,'Units','normalized');
set(handles.text10,'FontUnits','normalized');
set(handles.text10,'FontName','Arial');

set(handles.text11,'Units','normalized');
set(handles.text11,'FontUnits','normalized');
set(handles.text11,'FontName','Arial');

set(handles.text12,'Units','normalized');
set(handles.text12,'FontUnits','normalized');
set(handles.text12,'FontName','Arial');

set(handles.text13,'Units','normalized');
set(handles.text13,'FontUnits','normalized');
set(handles.text13,'FontName','Arial');

set(handles.text14,'Units','normalized');
set(handles.text14,'FontUnits','normalized');
set(handles.text14,'FontName','Arial');

set(handles.text15,'Units','normalized');
set(handles.text15,'FontUnits','normalized');
set(handles.text15,'FontName','Arial');

set(handles.text16,'Units','normalized');
set(handles.text16,'FontUnits','normalized');
set(handles.text16,'FontName','Arial');

set(handles.text17,'Units','normalized');
set(handles.text17,'FontUnits','normalized');
set(handles.text17,'FontName','Arial');

set(handles.text18,'Units','normalized');
set(handles.text18,'FontUnits','normalized');
set(handles.text18,'FontName','Arial');

set(handles.text19,'Units','normalized');
set(handles.text19,'FontUnits','normalized');
set(handles.text19,'FontName','Arial');

set(handles.text20,'Units','normalized');
set(handles.text20,'FontUnits','normalized');
set(handles.text20,'FontName','Arial');

set(handles.text21,'Units','normalized');
set(handles.text21,'FontUnits','normalized');
set(handles.text21,'FontName','Arial');

set(handles.text22,'Units','normalized');
set(handles.text22,'FontUnits','normalized');
set(handles.text22,'FontName','Arial');

set(handles.text23,'Units','normalized');
set(handles.text23,'FontUnits','normalized');
set(handles.text23,'FontName','Arial');

set(handles.text24,'Units','normalized');
set(handles.text24,'FontUnits','normalized');
set(handles.text24,'FontName','Arial');

% set(handles.text25,'Units','normalized');
% set(handles.text25,'FontUnits','normalized');
% set(handles.text25,'FontName','Arial');
% 
% set(handles.text26,'Units','normalized');
% set(handles.text26,'FontUnits','normalized');
% set(handles.text26,'FontName','Arial');
% 
% set(handles.text27,'Units','normalized');
% set(handles.text27,'FontUnits','normalized');
% set(handles.text27,'FontName','Arial');

%file options panel
set(handles.edit_directory,'Units','normalized');
set(handles.edit_directory,'FontUnits','normalized');
set(handles.edit_directory,'FontName','Arial');

set(handles.edit_stem,'Units','normalized');
set(handles.edit_stem,'FontUnits','normalized');
set(handles.edit_stem,'FontName','Arial');

set(handles.edit_exten,'Units','normalized');
set(handles.edit_exten,'FontUnits','normalized');
set(handles.edit_exten,'FontName','Arial');

set(handles.button_load,'Units','normalized');
set(handles.button_load,'FontUnits','normalized');
set(handles.button_load,'FontName','Arial');

%Plot options panel
set(handles.edit_dimages,'Units','normalized');
set(handles.edit_dimages,'FontUnits','normalized');
set(handles.edit_dimages,'FontName','Arial');

set(handles.checkbox_subdark,'Units','normalized');
set(handles.checkbox_subdark,'FontUnits','normalized');
set(handles.checkbox_subdark,'FontName','Arial');

set(handles.checkbox_norm1,'Units','normalized');
set(handles.checkbox_norm1,'FontUnits','normalized');
set(handles.checkbox_norm1,'FontName','Arial');

set(handles.checkbox_norm2,'Units','normalized');
set(handles.checkbox_norm2,'FontUnits','normalized');
set(handles.checkbox_norm2,'FontName','Arial');

set(handles.edit_normFile,'Units','normalized');
set(handles.edit_normFile,'FontUnits','normalized');
set(handles.edit_normFile,'FontName','Arial');

set(handles.button_openNorm,'Units','normalized');
set(handles.button_openNorm,'FontUnits','normalized');
set(handles.button_openNorm,'FontName','Arial');

%Image control panel
set(handles.edit_indexL,'Units','normalized');
set(handles.edit_indexL,'FontUnits','normalized');
set(handles.edit_indexL,'FontName','Arial');

set(handles.edit_indexR,'Units','normalized');
set(handles.edit_indexR,'FontUnits','normalized');
set(handles.edit_indexR,'FontName','Arial');

set(handles.text_count,'Units','normalized');
set(handles.text_count,'FontUnits','normalized');
set(handles.text_count,'FontName','Arial');

set(handles.button_minus,'Units','normalized');
set(handles.button_minus,'FontUnits','normalized');
set(handles.button_minus,'FontName','Arial');

set(handles.button_plus,'Units','normalized');
set(handles.button_plus,'FontUnits','normalized');
set(handles.button_plus,'FontName','Arial');

%Experiment parameters panel
set(handles.edit_energy,'Units','normalized');
set(handles.edit_energy,'FontUnits','normalized');
set(handles.edit_energy,'FontName','Arial');

set(handles.edit_distance,'Units','normalized');
set(handles.edit_distance,'FontUnits','normalized');
set(handles.edit_distance,'FontName','Arial');

set(handles.edit_pixel,'Units','normalized');
set(handles.edit_pixel,'FontUnits','normalized');
set(handles.edit_pixel,'FontName','Arial');

set(handles.edit_exposure,'Units','normalized');
set(handles.edit_exposure,'FontUnits','normalized');
set(handles.edit_exposure,'FontName','Arial');

set(handles.edit_normOffset,'Units','normalized');
set(handles.edit_normOffset,'FontUnits','normalized');
set(handles.edit_normOffset,'FontName','Arial');

%Additional Options - Additional Plots

set(handles.radiobutton_diff,'Units','normalized');
set(handles.radiobutton_diff,'FontUnits','normalized');
set(handles.radiobutton_diff,'FontName','Arial');

set(handles.radiobutton_summation,'Units','normalized');
set(handles.radiobutton_summation,'FontUnits','normalized');
set(handles.radiobutton_summation,'FontName','Arial');

set(handles.radiobutton_radial,'Units','normalized');
set(handles.radiobutton_radial,'FontUnits','normalized');
set(handles.radiobutton_radial,'FontName','Arial');

%Additional Options - Addition Plot Options
set(handles.checkbox_subdark2,'Units','normalized');
set(handles.checkbox_subdark2,'FontUnits','normalized');
set(handles.checkbox_subdark2,'FontName','Arial');

set(handles.checkbox_average,'Units','normalized');
set(handles.checkbox_average,'FontUnits','normalized');
set(handles.checkbox_average,'FontName','Arial');

set(handles.checkbox_norm3,'Units','normalized');
set(handles.checkbox_norm3,'FontUnits','normalized');
set(handles.checkbox_norm3,'FontName','Arial');

%Radial Intrgration Properties

set(handles.edit_angle,'Units','normalized');
set(handles.edit_angle,'FontUnits','normalized');
set(handles.edit_angle,'FontName','Arial');

set(handles.edit_spread,'Units','normalized');
set(handles.edit_spread,'FontUnits','normalized');
set(handles.edit_spread,'FontName','Arial');

set(handles.edit_x,'Units','normalized');
set(handles.edit_x,'FontUnits','normalized');
set(handles.edit_x,'FontName','Arial');

set(handles.edit_y,'Units','normalized');
set(handles.edit_y,'FontUnits','normalized');
set(handles.edit_y,'FontName','Arial');

set(handles.edit_radius,'Units','normalized');
set(handles.edit_radius,'FontUnits','normalized');
set(handles.edit_radius,'FontName','Arial');

set(handles.edit_radius2,'Units','normalized');
set(handles.edit_radius2,'FontUnits','normalized');
set(handles.edit_radius2,'FontName','Arial');

set(handles.button_conv1,'Units','normalized');
set(handles.button_conv1,'FontUnits','normalized');
set(handles.button_conv1,'FontName','Arial');

set(handles.edit_radNum,'Units','normalized');
set(handles.edit_radNum,'FontUnits','normalized');
set(handles.edit_radNum,'FontName','Arial');

set(handles.button_imcImage,'Units','normalized');
set(handles.button_imcImage,'FontUnits','normalized');
set(handles.button_imcImage,'FontName','Arial');

set(handles.button_imcDiff,'Units','normalized');
set(handles.button_imcDiff,'FontUnits','normalized');
set(handles.button_imcDiff,'FontName','Arial');

set(handles.button_imcSum,'Units','normalized');
set(handles.button_imcSum,'FontUnits','normalized');
set(handles.button_imcSum,'FontName','Arial');

set(handles.checkbox_bins,'Units','normalized');
set(handles.checkbox_bins,'FontUnits','normalized');
set(handles.checkbox_bins,'FontName','Arial');

set(handles.edit_bins,'Units','normalized');
set(handles.edit_bins,'FontUnits','normalized');
set(handles.edit_bins,'FontName','Arial');

set(handles.text_bnumber,'Units','normalized');
set(handles.text_bnumber,'FontUnits','normalized');
set(handles.text_bnumber,'FontName','Arial');

set(handles.button_binMinus,'Units','normalized');
set(handles.button_binMinus,'FontUnits','normalized');
set(handles.button_binMinus,'FontName','Arial');

set(handles.button_binPlus,'Units','normalized');
set(handles.button_binPlus,'FontUnits','normalized');
set(handles.button_binPlus,'FontName','Arial');

set(handles.button_refresh,'Units','normalized');
set(handles.button_refresh,'FontUnits','normalized');
set(handles.button_refresh,'FontName','Arial');

set(handles.button_calc,'Units','normalized');
set(handles.button_calc,'FontUnits','normalized');
set(handles.button_calc,'FontName','Arial');

%Intensity Scales

set(handles.edit_scaleLeftL,'Units','normalized');
set(handles.edit_scaleLeftL,'FontUnits','normalized');
set(handles.edit_scaleLeftL,'FontName','Arial');

set(handles.edit_scaleLeftU,'Units','normalized');
set(handles.edit_scaleLeftU,'FontUnits','normalized');
set(handles.edit_scaleLeftU,'FontName','Arial');

set(handles.edit_scaleRightL,'Units','normalized');
set(handles.edit_scaleRightL,'FontUnits','normalized');
set(handles.edit_scaleRightL,'FontName','Arial');

set(handles.edit_scaleRightU,'Units','normalized');
set(handles.edit_scaleRightU,'FontUnits','normalized');
set(handles.edit_scaleRightU,'FontName','Arial');

set(handles.edit_scaleSpecL,'Units','normalized');
set(handles.edit_scaleSpecL,'FontUnits','normalized');
set(handles.edit_scaleSpecL,'FontName','Arial');

set(handles.edit_scaleSpecU,'Units','normalized');
set(handles.edit_scaleSpecU,'FontUnits','normalized');
set(handles.edit_scaleSpecU,'FontName','Arial');

%Integration x-axis Units

set(handles.radiobutton_unitsTheta,'Units','normalized');
set(handles.radiobutton_unitsTheta,'FontUnits','normalized');
set(handles.radiobutton_unitsTheta,'FontName','Arial');

set(handles.radiobutton_unitsDSpace,'Units','normalized');
set(handles.radiobutton_unitsDSpace,'FontUnits','normalized');
set(handles.radiobutton_unitsDSpace,'FontName','Arial');