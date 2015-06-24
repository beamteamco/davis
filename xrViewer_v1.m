function varargout = xrViewer_v1(varargin)
%XRVIEWER_V1 M-file for xrViewer_v1.fig
%      XRVIEWER_V1, by itself, creates a new XRVIEWER_V1 or raises the existing
%      singleton*.
%
%      H = XRVIEWER_V1 returns the handle to a new XRVIEWER_V1 or the handle to
%      the existing singleton*.
%
%      XRVIEWER_V1('Property','Value',...) creates a new XRVIEWER_V1 using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to xrViewer_v1_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      XRVIEWER_V1('CALLBACK') and XRVIEWER_V1('CALLBACK',hObject,...) call the
%      local function named CALLBACK in XRVIEWER_V1.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help xrViewer_v1

% Last Modified by GUIDE v2.5 23-Jun-2015 09:53:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @xrViewer_v1_OpeningFcn, ...
                   'gui_OutputFcn',  @xrViewer_v1_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before xrViewer_v1 is made visible.
function xrViewer_v1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for xrViewer_v1
handles.output = hObject;

set(handles.button_openDir,'CData',imread('icon_folder.png'));
set(handles.button_openNorm,'CData',imread('icon_folder.png'));

handles.scale_left_L = 0;
handles.scale_left_U = 2000;
handles.scale_right_L = 0;
handles.scale_right_U = 2000;
handles.scale_spec_L = 0;
handles.scale_spec_U = 2000;

handles.imageIndexL = 0;
handles.imageIndexR = 0;
handles.imageIndexS = 0;

handles.darkNum = [0];
handles.loaded = 0;
handles.count=0;
handles.directory = '1';
%bin related handles
handles.binDir = [];
handles.binStem = 'binout_';
handles.binExten = '.png';
handles.binImages = {};
handles.binIndex = 1;
handles.binInfo = [];

%calculation related handles
handles.dR = 0.5;
handles.dTheta = 0.1;

%bin video related options
handles.resolutionW = 1200;
handles.resolutionH = 900;
handles.vidFormat = '.avi';
handles.vidFramerate = 5;
handles.norm = [];
setappdata(handles.axes_spec,'type',1);

set(handles.axes_left,'UIContextMenu',handles.plot_men1);
set(handles.axes_right,'UIContextMenu',handles.plot_men2);
set(handles.axes_spec,'UIContextMenu',handles.plot_men3);
set(gcf,'name','XRay Viewer and Data Analyzer')
% set(handles.button_conv1,'String','pc <-> 2\theta');


sIM = imread('no_image.png');

axes(handles.axes_left);
image(sIM);
axes(handles.axes_right);
image(sIM);
axes(handles.axes_spec);
image(sIM);
    
set(handles.button_calc,'UserData',0);
set(handles.button_conv1,'UserData',0);

set(handles.button_binMinus,'UserData',0);
set(handles.button_binPlus,'UserData',0);

set(handles.axes_spec,'Units','normalized');
set(handles.axes_spec,'OuterPosition',[0,0,1,1]);
axes(handles.axes_spec)
axis square        
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes xrViewer_v1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = xrViewer_v1_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_indexL_Callback(hObject, eventdata, handles)
% hObject    handle to edit_indexL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_indexL as text
%        str2double(get(hObject,'String')) returns contents of edit_indexL as a double

if(~isempty(str2double(get(handles.edit_indexL,'String'))))
    if(handles.count == 0)
        
    elseif(str2double(get(handles.edit_indexL,'String'))>=handles.count)
        set(handles.edit_indexL,'String',num2str(handles.count-1));
        handles.imageIndexL = handles.count-1;
    elseif(str2double(get(handles.edit_indexL,'String'))<0)
        set(handles.edit_indexL,'String',num2str(0));
        handles.imageIndexL = 0;
    elseif(isnan(str2double(get(handles.edit_indexL,'String'))))
        set(handles.edit_indexL,'String',num2str(handles.imageIndexL));
    else
        handles.imageIndexL = str2double(get(handles.edit_indexL,'String'));
    end
else
    set(handles.edit_indexL,'String',num2str(handles.imageIndexL));
end
    
updatePlots(hObject,handles);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_indexL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_indexL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_indexR_Callback(hObject, eventdata, handles)
% hObject    handle to edit_indexR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_indexR as text
%        str2double(get(hObject,'String')) returns contents of edit_indexR as a double

if(~isempty(str2double(get(handles.edit_indexR,'String'))))
    if(handles.count == 0)
        
    elseif(str2double(get(handles.edit_indexR,'String'))>=handles.count)
        set(handles.edit_indexR,'String',num2str(handles.count-1));
        handles.imageIndexR = handles.count-1;
    elseif(str2double(get(handles.edit_indexR,'String'))<0)
        set(handles.edit_indexR,'String',num2str(0));
        handles.imageIndexR = 0;
    elseif(isnan(str2double(get(handles.edit_indexR,'String'))))
        set(handles.edit_indexR,'String',num2str(handles.imageIndexR));
    else
        handles.imageIndexR = str2double(get(handles.edit_indexR,'String'));
    end
else
    set(handles.edit_indexR,'String',num2str(handles.imageIndexR));
end

updatePlots(hObject,handles);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_indexR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_indexR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_minus.
function button_minus_Callback(hObject, eventdata, handles)
% hObject    handle to button_minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(str2double(get(handles.edit_indexL,'String'))-1<handles.count)
    set(handles.edit_indexL,'String',num2str(str2double(get(handles.edit_indexL,'String'))-1));
    handles.imageIndexL = str2double(get(handles.edit_indexL,'String'))-1;
end
if(str2double(get(handles.edit_indexR,'String'))-1<handles.count)
    set(handles.edit_indexR,'String',num2str(str2double(get(handles.edit_indexR,'String'))-1));
    handles.imageIndexR = str2double(get(handles.edit_indexR,'String'))-1;
end
updatePlots(hObject,handles);
guidata(hObject,handles);

% --- Executes on button press in button_plus.
function button_plus_Callback(hObject, eventdata, handles)
% hObject    handle to button_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(str2double(get(handles.edit_indexL,'String'))+1<handles.count)
    set(handles.edit_indexL,'String',num2str(str2double(get(handles.edit_indexL,'String'))+1));
    handles.imageIndexL = str2double(get(handles.edit_indexL,'String'))+1;
end
if(str2double(get(handles.edit_indexR,'String'))+1<handles.count)
    set(handles.edit_indexR,'String',num2str(str2double(get(handles.edit_indexR,'String'))+1));
    handles.imageIndexR = str2double(get(handles.edit_indexR,'String'))+1;
end
updatePlots(hObject,handles);
guidata(hObject,handles);

function edit_dimages_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dimages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dimages as text
%        str2double(get(hObject,'String')) returns contents of edit_dimages as a double

if(~isempty(str2num(get(handles.edit_dimages,'String'))))
    temp = str2num(get(handles.edit_dimages,'String'));
end
flag=0;
for(i=1:length(temp))
    if(temp(i) >= handles.count || temp(i) < 0)
        flag=1;
    end
end
if(flag==0)
    handles.darkNum = temp;
else
    tstring='';
    for(i=1:length(handles.darkNum))
        if(i==1)
            tstring = num2str(handles.darkNum(i));
        else
            tstring = [tstring,',',num2str(handles.darkNum(i))];
        end
    end
    set(handles.edit_dimages,'String',tstring);
end
disp(handles.darkNum);
% disp(handles.darkNum)
if(handles.loaded ==1)
    if(~isnan(handles.darkNum))
        for i=1:length(handles.darkNum)
            if(i==1)
                temp = handles.images{handles.darkNum(i)+1};
            else
                temp = temp + handles.images{handles.darkNum(i)+1};
            end
        end
        handles.dark = temp/length(handles.darkNum);
    else
        handles.dark = zeros(2048,2048);
    end
end

updatePlots(hObject,handles);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_dimages_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dimages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_subdark.
function checkbox_subdark_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_subdark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_subdark
updatePlots(hObject,handles);
guidata(hObject,handles)

% --- Executes on button press in checkbox_norm1.
function checkbox_norm1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_norm1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_norm1
updatePlots(hObject,handles);
guidata(hObject,handles)


function edit_directory_Callback(hObject, eventdata, handles)
% hObject    handle to edit_directory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_directory as text
%        str2double(get(hObject,'String')) returns contents of edit_directory as a double


% --- Executes during object creation, after setting all properties.
function edit_directory_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_directory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_stem_Callback(hObject, eventdata, handles)
% hObject    handle to edit_stem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_stem as text
%        str2double(get(hObject,'String')) returns contents of edit_stem as a double
handles.stem = get(handles.edit_stem,'String');
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit_stem_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_stem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_openDir.
function button_openDir_Callback(hObject, eventdata, handles)
% hObject    handle to button_openDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.directory = uigetdir('','Choose Directory');
extenL = length(get(handles.edit_exten,'String'));
% disp(handles.directory);

if(length(handles.directory)~=1)
    set(handles.edit_directory,'String',handles.directory);
    handles.D=dir(handles.directory);
    stemEnd=-1;
    
    for i=1:length(handles.D)
        if(handles.D(i).name(1)~='.')
            for j=1:length(handles.D(i).name)
                if(handles.D(i).name(j)=='0')
                    stemEnd = j-1;
                    handles.stem = handles.D(i).name(1:stemEnd);
                    handles.numLength = length(handles.D(i).name)-stemEnd-extenL; %5 is for file extension (.tiff)
                    set(handles.edit_stem,'String',handles.stem);
                    break;
                end
            end
            if(stemEnd~=-1)
                break;
            end
        end
%       disp(D(i).name);
    end
%     disp(handles.numLength);
end

guidata(hObject,handles);


% --- Executes on button press in button_load.
function button_load_Callback(hObject, eventdata, handles)
% hObject    handle to button_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(length(handles.directory)~=1)
    handles.loaded = 0;
    handles.count=0;
    handles.images={};


    ct=1;
    for i=1:length(handles.D)
        if(~isempty(strfind(char({handles.D(i).name}),handles.stem)))
            t(ct) = {handles.D(i).name};
            ct=ct+1;
        end    
    end
    handles.imageNames = t';
    handles.count = length(handles.imageNames);
    set(handles.text_count,'String',['Count: ',num2str(handles.count)]);


    % disp(handles.imageNames{1,1});

    for i=1:handles.count
    %     disp([handles.directory,'\',handles.imageNames{i,1}])
        handles.images(i) = {ReadInGE([handles.directory,'\',handles.imageNames{i}])};
        disp([handles.directory,'\',handles.imageNames{i}])
    end

    if(handles.loaded==0)
        %creates the intial dark image
        for i=1:length(handles.darkNum)
            if(i==1)
                temp = handles.images{handles.darkNum(i)+1};
            else
                temp = temp + handles.images{handles.darkNum(i)+1};
            end
        end
        handles.dark = temp/length(handles.darkNum);
        
        handles.normVals = ones(1,handles.count);
        
        if(handles.count==1)
            set(handles.edit_indexL,'String','0');
            handles.imageIndexL = 0;
            set(handles.edit_indexR,'String','0');
            handles.imageIndexR = 0;
        elseif(handles.count > 1)
            set(handles.edit_indexL,'String','0');
            handles.imageIndexL = 0;
            set(handles.edit_indexR,'String','1');
            handles.imageIndexR = 1;
        end
        handles.loaded=1;
    end


    %plots the figures
    updatePlots(hObject,handles);
end
guidata(hObject,handles)


% --- Executes on button press in radiobutton_diff.
function radiobutton_diff_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_diff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_diff

% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(get(handles.radiobutton_diff,'Value')==1)
    set(handles.checkbox_subdark2,'Enable','off');
    set(handles.checkbox_average,'Enable','off');
    set(handles.checkbox_norm3,'Enable','off');
    set(handles.button_binMinus,'Enable','off');
    set(handles.button_binPlus,'Enable','off');
    set(handles.radiobutton_unitsTheta,'Enable','off');
    set(handles.radiobutton_unitsDSpace,'Enable','off');
elseif(get(handles.radiobutton_summation,'Value')==1)
    set(handles.checkbox_subdark2,'Enable','on');
    set(handles.checkbox_average,'Enable','on');
    set(handles.checkbox_norm3,'Enable','on');
    set(handles.button_binMinus,'Enable','off');
    set(handles.button_binPlus,'Enable','off');
    set(handles.radiobutton_unitsTheta,'Enable','off');
    set(handles.radiobutton_unitsDSpace,'Enable','off');
elseif(get(handles.radiobutton_radial,'Value')==1)
    set(handles.checkbox_subdark2,'Enable','on');
    set(handles.checkbox_average,'Enable','off');
    set(handles.checkbox_norm3,'Enable','on');
    set(handles.button_binMinus,'Enable','on');
    set(handles.button_binPlus,'Enable','on');
    set(handles.radiobutton_unitsTheta,'Enable','on');
    set(handles.radiobutton_unitsDSpace,'Enable','on');
end

updatePlots(hObject,handles);
guidata(hObject,handles)

% --- Executes on button press in checkbox_subdark2.
function checkbox_subdark2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_subdark2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_subdark2
updatePlots(hObject,handles);
guidata(hObject,handles)


% --- Executes on button press in checkbox_average.
function checkbox_average_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_average
updatePlots(hObject,handles);
guidata(hObject,handles)


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_exit_Callback(hObject, eventdata, handles)
% hObject    handle to menu_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in button_debug.
function button_debug_Callback(hObject, eventdata, handles)
% hObject    handle to button_debug (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
radialCompute(hObject,handles);


% --- Executes on mouse press over axes background.
function axes_left_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_5_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp = figure();
copyobj(handles.axes_left,temp);
cPos = get(temp,'Position');
set(temp,'Position',[55,200,600,600])
ax = get(temp,'CurrentAxes');

set(ax,'Units','normalized');
set(ax,'OuterPosition',[0 0 1 1]);
colorbar
% set(temp,'CurrentAxes',ax);
% --------------------------------------------------------------------
function plot_men1_Callback(hObject, eventdata, handles)
% hObject    handle to plot_men1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)figure


% --------------------------------------------------------------------
function Untitled_10_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp = figure();
copyobj(handles.axes_spec,temp);
cPos = get(temp,'Position');
set(temp,'Position',[55,200,600,600])
ax = get(temp,'CurrentAxes');

set(ax,'Units','normalized');
set(ax,'OuterPosition',[0 0 1 1]);

if(getappdata(handles.axes_spec,'type') == 1)
	colorbar
else
    colorbar('hide')
end

% --------------------------------------------------------------------
function Untitled_9_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp = figure();
copyobj(handles.axes_right,temp);
cPos = get(temp,'Position');
set(temp,'Position',[55,200,600,600])
ax = get(temp,'CurrentAxes');

set(ax,'Units','normalized');
set(ax,'OuterPosition',[0 0 1 1]);
colorbar

% --------------------------------------------------------------------
function plot_men2_Callback(hObject, eventdata, handles)
% hObject    handle to plot_men2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function plot_men3_Callback(hObject, eventdata, handles)
% hObject    handle to plot_men3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_angle_Callback(hObject, eventdata, handles)
% hObject    handle to edit_angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_angle as text
%        str2double(get(hObject,'String')) returns contents of edit_angle as a double
updatePlots(hObject,handles);
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_angle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_spread_Callback(hObject, eventdata, handles)
% hObject    handle to edit_spread (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_spread as text
%        str2double(get(hObject,'String')) returns contents of edit_spread as a double
updatePlots(hObject,handles);
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_spread_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_spread (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_radNum_Callback(hObject, eventdata, handles)
% hObject    handle to edit_radNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_radNum as text
%        str2double(get(hObject,'String')) returns contents of edit_radNum as a double

if(~isempty(str2double(get(handles.edit_radNum,'String'))))
    if(handles.count == 0)
        
    elseif(str2double(get(handles.edit_radNum,'String'))>=handles.count)
        set(handles.edit_radNum,'String',num2str(handles.count-1));
        handles.imageIndexS = handles.count-1;
    elseif(str2double(get(handles.edit_radNum,'String'))<0)
        set(handles.edit_radNum,'String',num2str(0));
        handles.imageIndexS = 0;
    elseif(isnan(str2double(get(handles.edit_radNum,'String'))))
        set(handles.edit_radNum,'String',num2str(handles.imageIndexS));
    else
        handles.imageIndexS = str2double(get(handles.edit_radNum,'String'));
    end
else
    set(handles.edit_radNum,'String',num2str(handles.edit_radNum));
end

updatePlots(hObject,handles);
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_radNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_radNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_calc.
function button_calc_Callback(hObject, eventdata, handles)
% hObject    handle to button_calc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.button_calc,'UserData',1);
[handles.binImages,handles.binLabels] = updatePlots(hObject,handles);
handles.binIndex = 1;
guidata(hObject,handles)

% --- Executes on button press in checkbox_vout.
function checkbox_vout_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_vout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_vout
updatePlots(hObject,handles);
guidata(hObject,handles)


function edit_x_Callback(hObject, eventdata, handles)
% hObject    handle to edit_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_x as text
%        str2double(get(hObject,'String')) returns contents of edit_x as a double
updatePlots(hObject,handles);
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_y as text
%        str2double(get(hObject,'String')) returns contents of edit_y as a double
updatePlots(hObject,handles);
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_radius_Callback(hObject, eventdata, handles)
% hObject    handle to edit_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_radius as text
%        str2double(get(hObject,'String')) returns contents of edit_radius as a double
updatePlots(hObject,handles);
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_refresh.
function button_refresh_Callback(hObject, eventdata, handles)
% hObject    handle to button_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updatePlots(hObject,handles);
guidata(hObject,handles)



function edit_exten_Callback(hObject, eventdata, handles)
% hObject    handle to edit_exten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_exten as text
%        str2double(get(hObject,'String')) returns contents of edit_exten as a double


% --- Executes during object creation, after setting all properties.
function edit_exten_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_exten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_radius2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_radius2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_radius2 as text
%        str2double(get(hObject,'String')) returns contents of edit_radius2 as a double
updatePlots(hObject,handles);
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_radius2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_radius2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_energy_Callback(hObject, eventdata, handles)
% hObject    handle to edit_energy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_energy as text
%        str2double(get(hObject,'String')) returns contents of edit_energy as a double


% --- Executes during object creation, after setting all properties.
function edit_energy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_energy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_distance_Callback(hObject, eventdata, handles)
% hObject    handle to edit_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_distance as text
%        str2double(get(hObject,'String')) returns contents of edit_distance as a double


% --- Executes during object creation, after setting all properties.
function edit_distance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_bins.
function checkbox_bins_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_bins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_bins
if(get(handles.checkbox_bins,'Value')==1)
    set(handles.edit_spread,'Enable','off');
    set(handles.edit_bins,'Enable','on');
else
    set(handles.edit_spread,'Enable','on');
    set(handles.edit_bins,'Enable','off');
end
updatePlots(hObject,handles);
guidata(hObject,handles)

function edit_bins_Callback(hObject, eventdata, handles)
% hObject    handle to edit_bins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_bins as text
%        str2double(get(hObject,'String')) returns contents of edit_bins as a double
updatePlots(hObject,handles);
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_bins_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_bins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_norm2.
function checkbox_norm2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_norm2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_norm2
updatePlots(hObject,handles);
guidata(hObject,handles)

% --- Executes on button press in button_openNorm.
function button_openNorm_Callback(hObject, eventdata, handles)
% hObject    handle to button_openNorm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[t1,t2] = uigetfile({'*.mcs','Normalization File (*.mcs)';'*.*','All Files (*.*)'},'Select File');
tempFilename = [t2,t1];
disp(tempFilename)

if(length(t1)~=1)
    set(handles.edit_normFile,'String',tempFilename);
    fs = fopen(tempFilename,'r','n');
    
    i=1;
    while(true)
        temp = fgetl(fs);
        if(~isnumeric(temp))
            inFile{i,1} = temp;
            i=i+1;
        else
            break;
        end
    end
    fclose(fs);
    disp('file closed');

    t = [];
    handles.norm = [];
    x=1;
    for(j=1:size(inFile,1))
        for(i=1:length(inFile{j,1}))
            t = [t,inFile{j,1}(i)];
            if((strcmp(inFile{j,1}(i),' ') || i==length(inFile{j,1}) )&& ~strcmp(t(1),'#'))
    %             disp(rt)
                handles.norm(x,1) = str2double(t);
                t=[];
                x=x+1;
            end
        end
        t=[];
    end
    ts = 0:(1/.01)/length(handles.norm):(1/.01)-(1/.01)/length(handles.norm);

    norm2 = handles.norm - mean(handles.norm);
    
    figure
    subplot(4,1,1)
    plot(0:.01:0.01*length(handles.norm)-.01,handles.norm)
    xlabel('Time (s)')
    ylabel('Current (mA)')

    subplot(4,1,2)
    plot(0:.01:0.01*length(handles.norm)-.01,norm2)
    xlabel('Time (s)')
    ylabel('Current (ma) ')
    
    subplot(4,1,3);
    ffout = abs(fft(norm2));
    
    hpass = ones(size(handles.norm,1),1);
    hpass(1:round(length(hpass)/40))=0;
    
    disp(size(hpass))
    disp(size(ffout))
    
%     ffout = ffout.*hpass;
    plot(ts,ffout);
    xlabel('Frequency (Hz)')
    ylabel('|F(t)|')
    
    ylim([0,2000])
    subplot(4,1,4)    
    spectrogram(norm2,floor(length(handles.norm)/60),floor(length(handles.norm)/120),6095,1/.01,'yaxis');
    colormap jet
    
%     figure
% %     tesst = [1,2,3,3,4,2,3,4,3,2,5,6,7,7,4,5,6,3,3,4];
% %     plot(0:1:length(norm2)-1,norm2);
%     stem(1:1:length(norm2),norm2);
%     hold on
%     
%     iFactor = 4;
%     interped = sincinterp(norm2,iFactor,1);
%     disp(length(interped))
%     
%     plot(0:1/iFactor:length(norm2)-1/iFactor,interped);
%     
%     hold off
    
    %photon counts
    eCharge = 1.602*10^(-19);
%     tCount = handles.norm/eCharge; %per second
    exposure = str2double(get(handles.edit_exposure,'String'));
    
    div = floor(exposure/0.01);
    residue = mod(exposure,0.01);
    tOffset = str2double(get(handles.edit_normOffset,'String'));
    handles.normVals = [];
    disp(size(handles.norm));
    if(handles.loaded == 1)
        if(handles.count*exposure > length(handles.norm)*0.01)
            msgbox('Theres not enough beam current data to normalize all the images given the exposure time.');
        else
            for(i=1:handles.count)
                handles.normVals(i) = specIntegrate(handles.norm,(length(handles.norm)-1)*0.01,(i-1)*exposure+tOffset,(i)*exposure+tOffset)/exposure;
            end
        end
        disp(sum(sum(handles.images{7})));
    end
%     handles.normVals = handles.normVals*0.001/eCharge;
    meanNorm = mean(handles.normVals);
    disp(handles.normVals);
    handles.normVals = handles.normVals/meanNorm;
    disp(handles.normVals);
    set(handles.checkbox_norm2,'Enable','on');
%     figure
end
guidata(hObject, handles);


function edit_normFile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_normFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_normFile as text
%        str2double(get(hObject,'String')) returns contents of edit_normFile as a double


% --- Executes during object creation, after setting all properties.
function edit_normFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_normFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_pixel_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pixel as text
%        str2double(get(hObject,'String')) returns contents of edit_pixel as a double


% --- Executes during object creation, after setting all properties.
function edit_pixel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_scaleRightL_Callback(hObject, eventdata, handles)
% hObject    handle to edit_scaleRightL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_scaleRightL as text
%        str2double(get(hObject,'String')) returns contents of edit_scaleRightL as a double
handles.scale_right_L = str2double(get(handles.edit_scaleRightL,'String'));
updatePlots(hObject,handles);
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_scaleRightL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_scaleRightL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_scaleRightU_Callback(hObject, eventdata, handles)
% hObject    handle to edit_scaleRightU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_scaleRightU as text
%        str2double(get(hObject,'String')) returns contents of edit_scaleRightU as a double
handles.scale_right_U = str2double(get(handles.edit_scaleRightU,'String'));
updatePlots(hObject,handles);
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_scaleRightU_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_scaleRightU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_scaleLeftL_Callback(hObject, eventdata, handles)
% hObject    handle to edit_scaleLeftL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_scaleLeftL as text
%        str2double(get(hObject,'String')) returns contents of edit_scaleLeftL as a double
handles.scale_left_L = str2double(get(handles.edit_scaleLeftL,'String'));
updatePlots(hObject,handles);
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_scaleLeftL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_scaleLeftL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_scaleLeftU_Callback(hObject, eventdata, handles)
% hObject    handle to edit_scaleLeftU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_scaleLeftU as text
%        str2double(get(hObject,'String')) returns contents of edit_scaleLeftU as a double
handles.scale_left_U = str2double(get(handles.edit_scaleLeftU,'String'));
updatePlots(hObject,handles);
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_scaleLeftU_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_scaleLeftU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_scaleSpecU_Callback(hObject, eventdata, handles)
% hObject    handle to edit_scaleSpecU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_scaleSpecU as text
%        str2double(get(hObject,'String')) returns contents of edit_scaleSpecU as a double
handles.scale_spec_U = str2double(get(handles.edit_scaleSpecU,'String'));
updatePlots(hObject,handles);
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_scaleSpecU_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_scaleSpecU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_scaleSpecL_Callback(hObject, eventdata, handles)
% hObject    handle to edit_scaleSpecL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_scaleSpecL as text
%        str2double(get(hObject,'String')) returns contents of edit_scaleSpecL as a double
handles.scale_spec_L = str2double(get(handles.edit_scaleSpecL,'String'));
updatePlots(hObject,handles);
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_scaleSpecL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_scaleSpecL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_norm3.
function checkbox_norm3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_norm3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_norm3
updatePlots(hObject,handles);
guidata(hObject,handles)


% --- Executes on button press in button_conv1.
function button_conv1_Callback(hObject, eventdata, handles)
% hObject    handle to button_conv1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pxLength = 10^(-6) * str2double(get(handles.edit_pixel,'String'));
dist = str2double(get(handles.edit_distance,'String'))/1000;


ru = str2double(get(handles.edit_radius,'String'));
rl = str2double(get(handles.edit_radius2,'String'));

if(get(handles.button_conv1,'UserData')==0)
    ru2 = atan(ru*pxLength/dist)*180/pi();
    rl2 = atan(rl*pxLength/dist)*180/pi();
    set(handles.button_conv1,'USerData',1);
elseif(get(handles.button_conv1,'UserData')==1)
    ru2 = tan(ru/(180/pi()))/(pxLength/dist);
    rl2 = tan(rl/(180/pi()))/(pxLength/dist);
    set(handles.button_conv1,'USerData',0);
end

set(handles.edit_radius,'String',num2str(ru2));
set(handles.edit_radius2,'String',num2str(rl2));

updatePlots(hObject,handles);
guidata(hObject,handles)


% --------------------------------------------------------------------
function Untitled_11_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_binpath_Callback(hObject, eventdata, handles)
% hObject    handle to menu_binpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.binDir = uigetdir('','Chose bin output file directory');
if(length(handles.binDir)~=1)
    prompt = {'File Stem','File Extension'};
    def = {handles.binStem,handles.binExten};
    x = inputdlg(prompt,'Additional Parameters',1,def);

    handles.binStem = x{1};
    handles.binExten = x{2};    
    
    disp(handles.binDir);
    disp(handles.binStem);
    disp(handles.binExten);
end
guidata(hObject,handles);


% --------------------------------------------------------------------
function menu_binvid_Callback(hObject, eventdata, handles)
% hObject    handle to menu_binvid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(strcmp(get(handles.menu_binvid,'Checked'),'on'))
    set(handles.menu_binvid,'Checked','off')
else
    set(handles.menu_binvid,'Checked','on')
end

guidata(hObject,handles);


% --- Executes on button press in button_binMinus.
function button_binMinus_Callback(hObject, eventdata, handles)
% hObject    handle to button_binMinus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.button_binMinus,'UserData',1);
[handles.binIndex,~] = updatePlots(hObject,handles);
guidata(hObject,handles);

% --- Executes on button press in button_binPlus.
function button_binPlus_Callback(hObject, eventdata, handles)
% hObject    handle to button_binPlus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.button_binPlus,'UserData',1);
[handles.binIndex,~] = updatePlots(hObject,handles);
guidata(hObject,handles)


% --------------------------------------------------------------------
function menu_calcparams_Callback(hObject, eventdata, handles)
% hObject    handle to menu_calcparams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'dR - rho size for bins in pixels (can be decimal)','dTheta - angle size for bins in degrees'};
def = {num2str(handles.dR),num2str(handles.dTheta)};
x = inputdlg(prompt,'Calculation Parameters',1,def);

if(~isempty(x))
    handles.dR = str2double(x{1});
    handles.dTheta = str2double(x{2});    
end

guidata(hObject, handles)


% --------------------------------------------------------------------
function menu_vidop_Callback(hObject, eventdata, handles)
% hObject    handle to menu_vidop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Resolution Width','Resolution Height','Video Format','Video Framerate'};
def = {num2str(handles.resolutionW),num2str(handles.resolutionH),handles.vidFormat,num2str(handles.vidFramerate)};
x = inputdlg(prompt,'Video Export Options',1,def);

if(~isempty(x))
    handles.resolutionW = str2double(x{1});
    handles.resolutionH = str2double(x{2});
    handles.vidFormat = x{3};
    handles.vidFramerate = str2double(x{4});
end

guidata(hObject, handles)


% --------------------------------------------------------------------
function menu_unpack_Callback(hObject, eventdata, handles)
% hObject    handle to menu_unpack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

unpacker();



function edit_exposure_Callback(hObject, eventdata, handles)
% hObject    handle to edit_exposure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_exposure as text
%        str2double(get(hObject,'String')) returns contents of edit_exposure as a double


% --- Executes during object creation, after setting all properties.
function edit_exposure_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_exposure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_normOffset_Callback(hObject, eventdata, handles)
% hObject    handle to edit_normOffset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_normOffset as text
%        str2double(get(hObject,'String')) returns contents of edit_normOffset as a double


% --- Executes during object creation, after setting all properties.
function edit_normOffset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_normOffset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uibuttongroup4.
function uibuttongroup4_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup4 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(get(handles.button_imcDiff,'Value')==1)
    set(handles.checkbox_subdark2,'Enable','off');
    set(handles.checkbox_average,'Enable','off');
    set(handles.checkbox_norm3,'Enable','off');
elseif(get(handles.button_imcSum,'Value')==1)
    set(handles.checkbox_subdark2,'Enable','on');
    set(handles.checkbox_average,'Enable','on');
    set(handles.checkbox_norm3,'Enable','on');
elseif(get(handles.button_imcImage,'Value')==1)
    set(handles.checkbox_subdark2,'Enable','on');
    set(handles.checkbox_average,'Enable','off');
    set(handles.checkbox_norm3,'Enable','on');
end

updatePlots(hObject,handles);
guidata(hObject,handles)


% --------------------------------------------------------------------
function Untitled_14_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x = getimage(handles.axes_spec);
% assignin('base','output',x);
if(size(x,3)==1)
        [t1,t2] = uiputfile({'*.tiff','TIFF File (*.tiff)'},'Save Sequence');
        filename = [t2,t1];
        disp(filename)
        disp(length(t1))
        if(length(t1)~=1)
            fs = fopen(filename,'w');
            fwrite(fs, x, 'uint16');
            close(fs);
            disp('File Saved Succesfully')
        end
else
    msgbox('Please export non-plot images');
end
% --------------------------------------------------------------------
function Untitled_13_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x = getimage(handles.axes_right);
if(size(x,3)==1)
        [t1,t2] = uiputfile({'*.tiff','TIFF File (*.tiff)'},'Save Sequence');
        filename = [t2,t1];
        disp(filename)
        disp(length(t1))
        if(length(t1)~=1)
            fs = fopen(filename,'w');
            fwrite(fs, x, 'uint16');
            close(fs);
            disp('File Saved Succesfully')
        end
else
    msgbox('Please export non-plot images');
end

% --------------------------------------------------------------------
function Untitled_12_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x = getimage(handles.axes_left);
if(size(x,3)==1)
        [t1,t2] = uiputfile({'*.tiff','TIFF File (*.tiff)'},'Save Sequence');
        filename = [t2,t1];
        disp(filename)
        disp(length(t1))
        if(length(t1)~=1)
            fs = fopen(filename,'w');
            fwrite(fs, x, 'uint16');
            close(fs);
            disp('File Saved Succesfully')
        end
else
    msgbox('Please export non-plot images');
end


% --------------------------------------------------------------------
function Untitled_15_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_larparmrefine_Callback(hObject, eventdata, handles)
% hObject    handle to menu_larparmrefine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
xrViewer_LatParmRefine();
