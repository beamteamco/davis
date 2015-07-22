function varargout = xrViewer_LatParmRefine(varargin)
% XRVIEWER_LATPARMREFINE MATLAB code for xrViewer_LatParmRefine.fig
%      XRVIEWER_LATPARMREFINE, by itself, creates a new XRVIEWER_LATPARMREFINE or raises the existing
%      singleton*.
%
%      H = XRVIEWER_LATPARMREFINE returns the handle to a new XRVIEWER_LATPARMREFINE or the handle to
%      the existing singleton*.
%
%      XRVIEWER_LATPARMREFINE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in XRVIEWER_LATPARMREFINE.M with the given input arguments.
%
%      XRVIEWER_LATPARMREFINE('Property','Value',...) creates a new XRVIEWER_LATPARMREFINE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before xrViewer_LatParmRefine_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to xrViewer_LatParmRefine_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help xrViewer_LatParmRefine

% Last Modified by GUIDE v2.5 22-Jul-2015 14:22:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @xrViewer_LatParmRefine_OpeningFcn, ...
                   'gui_OutputFcn',  @xrViewer_LatParmRefine_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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


% --- Executes just before xrViewer_LatParmRefine is made visible.
function xrViewer_LatParmRefine_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to xrViewer_LatParmRefine (see VARARGIN)

% Choose default command line output for xrViewer_LatParmRefine
handles.output = hObject;

handles.loaded = 0;
handles.DATA_INTENSITY = [];
handles.DATA_DSPACING = [];
handles.DATA_2THETA = [];

handles.DATA_MAXES = [,];
handles.binDATA = [];
handles.filename = '';
handles.lattice_params = [];
handles.DATA_INITSPACING = [];
handles.numBins = 0;
handles.binNum = str2double(get(handles.edit_binNum,'String'));

handles.DATA_FIT = {};

handles.maxParams = struct(...
    'Imin',0,...
    'Imax',3*10^4,...
    'SpacingMin',0.1);

set(handles.pushbutton_openFile,'CData',imread('icon_folder.png'));
set(gcf,'WindowButtonMotionFcn',@(gcf,eventdata)axesMouseOverCallback(gcf,hObject,handles));
set(handles.pushbutton_toolDel,'UserData',0);
set(gcf,'name','Lattice Parameter Refinement Tool')
set(handles.uitable_maxes,'Data',{});

if(isempty(varargin))
    handles.ENERGY = str2double(get(handles.edit_energy,'String'));
else
    handles.ENERGY = varargin;
end
set(handles.pushbutton_toolFndmax,'UserData',0);
handles.gdlines = [];
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes xrViewer_LatParmRefine wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = xrViewer_LatParmRefine_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_filename_Callback(hObject, eventdata, handles)
% hObject    handle to edit_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_filename as text
%        str2double(get(hObject,'String')) returns contents of edit_filename as a double


% --- Executes during object creation, after setting all properties.
function edit_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_openFile.
function pushbutton_openFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_openFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[t1,t2] = uigetfile({'*.mat','MAT File (*.mat)'},'Select File');
tempFilename = [t2,t1];
disp(tempFilename)
handles.filename = t1;
if(length(t1)~=1)
    x = load(tempFilename);

    handles.DATA_INTENSITY = [];
    handles.DATA_DSPACING = [];
    handles.DATA_2THETA = [];

    handles.DATA_MAXES = [,];
    handles.binDATA = [];

    handles.DATA_INITSPACING = [];
    handles.numBins = 0;
    handles.DATA_FIT = {};
    set(handles.edit_filename,'String',tempFilename);
    set(handles.edit_binNum,'String','1');

    handles.numBins = size(x.binData,2)/3;  
    disp(handles.numBins);
    handles.binNum = str2double(get(handles.edit_binNum,'String'));

    set(handles.text_numBins,'String',['# of bins = ',num2str(handles.numBins)]);
    
    handles.binDATA = cell2mat(x.binData(2:end-2,:));
    handles.DATA_INTENSITY = cell2mat(x.binData(2:end-2,3*(handles.binNum-1)+1));    
    handles.DATA_2THETA = cell2mat(x.binData(2:end-2,3*(handles.binNum-1)+2));
    handles.DATA_DSPACING = cell2mat(x.binData(2:end-2,3*(handles.binNum-1)+3));
    handles.ENERGY = cell2mat(x.binData(end,1));
    disp(handles.ENERGY);
    set(handles.edit_energy,'String',num2str(handles.ENERGY));
    handles.loaded = 1;
    
    handles.DATA_INITSPACING = [];
    initParms = [str2double(get(handles.edit_parmA,'String')),str2double(get(handles.edit_parmB,'String')),str2double(get(handles.edit_parmC,'String'))];
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

    [handles.DATA_INITSPACING,~] = PlaneSpacings(initParms,type,getHKLs(type),keV2Angstrom(handles.ENERGY));

%     disp(handles.DATA_INITSPACING(1))
    
    handles.lattice_params = zeros(handles.numBins,3);
    xrLatParmRefine_updatePlots(hObject,handles);
    
end
guidata(hObject,handles);


function edit_binNum_Callback(hObject, eventdata, handles)
% hObject    handle to edit_binNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_binNum as text
%        str2double(get(hObject,'String')) returns contents of edit_binNum as a double
if(handles.numBins == 0)
    set(handles.edit_binNum,'String','1');
else
    if(str2double(get(handles.edit_binNum,'String')) > handles.numBins)
        set(handles.edit_binNum,'String',num2str(handles.numBins));
        handles.binNum = handles.numBins;
        handles.DATA_INTENSITY = handles.binDATA(:,3*(handles.binNum-1)+1);    
        handles.DATA_2THETA = handles.binDATA(:,3*(handles.binNum-1)+2);
        handles.DATA_DSPACING = handles.binDATA(:,3*(handles.binNum-1)+3);
    elseif(str2double(get(handles.edit_binNum,'String')) < 1)
        set(handles.edit_binNum,'String','1');
        handles.binNum = 1;
        handles.DATA_INTENSITY = handles.binDATA(:,3*(handles.binNum-1)+1);    
        handles.DATA_2THETA = handles.binDATA(:,3*(handles.binNum-1)+2);
        handles.DATA_DSPACING = handles.binDATA(:,3*(handles.binNum-1)+3);
    else
        handles.binNum = str2double(get(handles.edit_binNum,'String'));
        handles.DATA_INTENSITY = handles.binDATA(:,3*(handles.binNum-1)+1);    
        handles.DATA_2THETA = handles.binDATA(:,3*(handles.binNum-1)+2);
        handles.DATA_DSPACING = handles.binDATA(:,3*(handles.binNum-1)+3);
    end
end
xrLatParmRefine_updatePlots(hObject,handles);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_binNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_binNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_YMax_Callback(hObject, eventdata, handles)
% hObject    handle to edit_YMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_YMax as text
%        str2double(get(hObject,'String')) returns contents of edit_YMax as a double
xrLatParmRefine_updatePlots(hObject,handles);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_YMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_YMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_YMin_Callback(hObject, eventdata, handles)
% hObject    handle to edit_YMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_YMin as text
%        str2double(get(hObject,'String')) returns contents of edit_YMin as a double
xrLatParmRefine_updatePlots(hObject,handles);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_YMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_YMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_XMax_Callback(hObject, eventdata, handles)
% hObject    handle to edit_XMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_XMax as text
%        str2double(get(hObject,'String')) returns contents of edit_XMax as a double
xrLatParmRefine_updatePlots(hObject,handles);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_XMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_XMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_XMin_Callback(hObject, eventdata, handles)
% hObject    handle to edit_XMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_XMin as text
%        str2double(get(hObject,'String')) returns contents of edit_XMin as a double
xrLatParmRefine_updatePlots(hObject,handles);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_XMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_XMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_autoY.
function checkbox_autoY_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_autoY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_autoY
xrLatParmRefine_updatePlots(hObject,handles);
guidata(hObject,handles);

% --- Executes on button press in checkbox_autoX.
function checkbox_autoX_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_autoX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_autoX
xrLatParmRefine_updatePlots(hObject,handles);
guidata(hObject,handles);

% --- Executes on button press in radiobutton_dspace.
function radiobutton_dspace_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_dspace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_dspace

set(handles.radiobutton_2theta,'Value',0);
set(handles.radiobutton_dspace,'Value',1);
set(handles.pushbutton_calcMax,'Enable','on');
set(handles.checkbox_initspacing,'Enable','on');
xrLatParmRefine_updatePlots(hObject,handles);
guidata(hObject,handles);

% --- Executes on button press in radiobutton_2theta.
function radiobutton_2theta_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_2theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_2theta
set(handles.radiobutton_dspace,'Value',0);
set(handles.radiobutton_2theta,'Value',1);
set(handles.pushbutton_calcMax,'Enable','off');
set(handles.checkbox_initspacing,'Enable','off');
xrLatParmRefine_updatePlots(hObject,handles);
guidata(hObject,handles);


% --- Executes on button press in pushbutton_calcMax.
function pushbutton_calcMax_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_calcMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
popval = get(handles.popupmenu_type,'Value');
disp('Maximum Calculation Parameters');
disp(handles.maxParams);
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

if(handles.loaded==1)
    z=1;
    handles.DATA_MAXES = [,];
    threshold = str2double(get(handles.edit_threshold,'String'));
    totmax = max(handles.DATA_INTENSITY);
    width = 1;
    pass = 0;
    
    numThresh = threshold*0.0001*totmax;
    disp(numThresh);
    
    %Redo indexperspace, nonlinaer relationship
    indexPerSpace = length(handles.DATA_DSPACING)/abs(handles.DATA_DSPACING(2)-handles.DATA_DSPACING(end));
    disp(abs(handles.DATA_DSPACING(2)-handles.DATA_DSPACING(end)))
    disp(handles.DATA_DSPACING)
    disp(['indexperspace = ',num2str(indexPerSpace)])
    for(i=2:length(handles.DATA_DSPACING)-1)        
        if((handles.DATA_INTENSITY(i) >= handles.maxParams.Imin) &&...
                (handles.DATA_INTENSITY(i) <= handles.maxParams.Imax) &&...
                (handles.DATA_INTENSITY(i) > handles.DATA_INTENSITY(i-1)) &&...
                (handles.DATA_INTENSITY(i) > handles.DATA_INTENSITY(i+1)))
            for(j=(i-floor(handles.maxParams.SpacingMin*indexPerSpace)):(i+floor(handles.maxParams.SpacingMin*indexPerSpace)))
                if(handles.DATA_INTENSITY(i) >= handles.DATA_INTENSITY(j))
                    pass=1;
                else
                    pass=0;
                    break;
                end
            end
            
            if(pass==1)
                indexx=1;
                handles.DATA_MAXES(z,1:2) = [handles.DATA_DSPACING(i),handles.DATA_INTENSITY(i)];
                handles.DATA_MAXES(z,3) = 0.25; 
                handles.DATA_MAXES(z,4) = handles.DATA_2THETA(i);
                for(k=1:length(handles.DATA_INITSPACING))
                    if(abs(handles.DATA_DSPACING(i)-handles.DATA_INITSPACING(k))<abs(handles.DATA_DSPACING(i)-handles.DATA_INITSPACING(indexx)))
                        indexx = k;
                    end                
                end
                handles.DATA_MAXES(z,5) = str2double([num2str(hkls(1,indexx)),num2str(hkls(2,indexx)),num2str(hkls(3,indexx))]);
                z=z+1;
            end 
        
        end    
    end
    
    handles.DATA_MAXES = orderSort(handles.DATA_MAXES,'a',1);
    if(~isempty(handles.DATA_MAXES))
        set(handles.uitable_maxes,'Data',[num2cell(handles.DATA_MAXES(:,1)),num2cell(handles.DATA_MAXES(:,2)),num2cell(handles.DATA_MAXES(:,3)),num2cell(handles.DATA_MAXES(:,5))]);
    else
        set(handles.uitable_maxes,'Data',{});
    end
    
% %     width2 = 0.05;
% %     scale = handles.DATA_DSPACING(1)-handles.DATA_DSPACING(end);
% %     disp('scale')
% %     disp(scale);
% %     
% %     tval = [];
% %     for(i=1:length(handles.DATA_MAXES))
% %         tval(i) = specIntegrate(handles.DATA_INTENSITY,scale,handles.DATA_MAXES(i,1)-width2/2,handles.DATA_MAXES(i,1)+width2/2);        
% %     end
% %     disp(tval);
% % %     figure
% % %     stem(tval);
    disp('Maximum Calculation Complete')
    set(handles.text_maxnum,'String',['Max # = ',num2str(size(handles.DATA_MAXES,1))]);
    xrLatParmRefine_updatePlots(hObject,handles);
else
    msgbox('Please load data before calculations');
end
% if(~isempty( handles.DATA_MAXES))
%     disp(handles.DATA_MAXES(:,1));
% end
guidata(hObject,handles);



function edit_threshold_Callback(hObject, eventdata, handles)
% hObject    handle to edit_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_threshold as text
%        str2double(get(hObject,'String')) returns contents of edit_threshold as a double


% --- Executes during object creation, after setting all properties.
function edit_threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_toolDel.
function pushbutton_toolDel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_toolDel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(get(handles.pushbutton_toolDel,'UserData')==0)
    set(handles.pushbutton_toolDel,'BackgroundColor',[.6,.6,.6]);
    set(handles.pushbutton_toolDel,'UserData',1);
else
    set(handles.pushbutton_toolDel,'BackgroundColor',[.92,.92,.92]);
    set(handles.pushbutton_toolDel,'UserData',0);
end

set(handles.pushbutton_toolFndmax,'BackgroundColor',[.92,.92,.92]);
set(handles.pushbutton_toolFndmax,'UserData',0);
guidata(hObject,handles);


% --- Executes on mouse press over axes background.
function axes_plot_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

resp = get(handles.axes_plot,'CurrentPoint');
disp(resp)
cX = resp(1,1);
cY = resp(1,2);
disp('clicker');
if(handles.loaded == 1)
    distr = -1;
    if(~isempty(handles.DATA_MAXES))
        radius = 0.005;
        distr = zeros(size(handles.DATA_MAXES,1),1);
        
        scaleY = get(handles.axes_plot,'YLim');
        scaleX = get(handles.axes_plot,'XLim');
        t = ones(size(handles.DATA_MAXES,1),1);
        normMatrix = [(scaleX(2)-scaleX(1))*t,(scaleY(2)-scaleY(1))*t];
        normed = handles.DATA_MAXES(:,1:2)./normMatrix;

        for(i=1:size(handles.DATA_MAXES,1))
            distr(i,1) = sqrt((normed(i,1)-cX/(scaleX(2)-scaleX(1)))^2+(normed(i,2)-cY/(scaleY(2)-scaleY(1)))^2);
        end
    end
    
    minIndex=-1;
    if(get(handles.pushbutton_toolDel,'UserData')==1)
        [tt,minIndex] = min(distr);
        disp('del')
        disp(tt)
        if(tt<0.04)
            if(size(handles.DATA_MAXES,1)>1)
                handles.DATA_MAXES = [handles.DATA_MAXES(1:minIndex-1,:);handles.DATA_MAXES(minIndex+1:end,:)];
            else
                handles.DATA_MAXES = [];
            end
        end
    end
    
    if(get(handles.pushbutton_toolFndmax,'UserData')==1)        
        handles.gdlines(1,1) = cX; 
        disp(cX);
    end
    if(get(handles.pushbutton_toolFndmax,'UserData')==2)        
        handles.gdlines(2,1) = cX;        
    end
    
    set(handles.text_maxnum,'String',['Max # = ',num2str(size(handles.DATA_MAXES,1))]);
%     disp(minIndex);
%     disp(get(handles.axes_plot,'Children'));
    if(get(handles.pushbutton_toolFndmax,'UserData')==2)        
        handles.DATA_MAXES(end+1,:) = xrLatParmRefine_updatePlots(hObject,handles);    
    end
    set(handles.text_maxnum,'String',['Max # = ',num2str(size(handles.DATA_MAXES,1))]);
    
    handles.DATA_MAXES = orderSort(handles.DATA_MAXES,'a',1);
    if(~isempty(handles.DATA_MAXES))
        set(handles.uitable_maxes,'Data',[num2cell(handles.DATA_MAXES(:,1)),num2cell(handles.DATA_MAXES(:,2)),num2cell(handles.DATA_MAXES(:,3)),num2cell(handles.DATA_MAXES(:,5))])
    else
        set(handles.uitable_maxes,'Data',{})
    end
    
    xrLatParmRefine_updatePlots(hObject,handles);  
end
guidata(hObject,handles);

function axesMouseOverCallback(a,hObject,handles)

%works for real time coordinates
% x = get(handles.axes_plot,'CurrentPoint');
% if(get(handles.pushbutton_toolFndmax,'UserData')==1)
%     disp(handles.loaded)
%     handles.curPoint = x(1);
%     xrLatParmRefine_updatePlots(hObject,handles);    
% end

% guidata(hObject,handles.axes_plot)

% --- Executes on button press in pushbutton_toolFndmax.
function pushbutton_toolFndmax_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_toolFndmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(get(handles.pushbutton_toolFndmax,'UserData')==0)
    set(handles.pushbutton_toolFndmax,'BackgroundColor',[.6,.6,.6]);
    set(handles.pushbutton_toolFndmax,'UserData',1);
else
    set(handles.pushbutton_toolFndmax,'BackgroundColor',[.92,.92,.92]);
    set(handles.pushbutton_toolFndmax,'UserData',0);
end

set(handles.pushbutton_toolDel,'BackgroundColor',[.92,.92,.92]);
set(handles.pushbutton_toolDel,'UserData',0);
guidata(hObject,handles);


% --- Executes on selection change in popupmenu_type.
function popupmenu_type_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_type
handles.DATA_INITSPACING = [];
initParms = [str2double(get(handles.edit_parmA,'String')),str2double(get(handles.edit_parmB,'String')),str2double(get(handles.edit_parmC,'String'))];
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
disp(initParms)
[handles.DATA_INITSPACING,~] = PlaneSpacings(initParms,type,getHKLs(type),keV2Angstrom(handles.ENERGY));
xrLatParmRefine_updatePlots(hObject,handles); 
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_parmA_Callback(hObject, eventdata, handles)
% hObject    handle to edit_parmA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_parmA as text
%        str2double(get(hObject,'String')) returns contents of edit_parmA as a double
handles.DATA_INITSPACING = [];
initParms = [str2double(get(handles.edit_parmA,'String')),str2double(get(handles.edit_parmB,'String')),str2double(get(handles.edit_parmC,'String'))];
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

[handles.DATA_INITSPACING,~] = PlaneSpacings(initParms,type,getHKLs(type),keV2Angstrom(handles.ENERGY));
xrLatParmRefine_updatePlots(hObject,handles); 
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_parmA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_parmA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_parmB_Callback(hObject, eventdata, handles)
% hObject    handle to edit_parmB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_parmB as text
%        str2double(get(hObject,'String')) returns contents of edit_parmB as a double
handles.DATA_INITSPACING = [];
initParms = [str2double(get(handles.edit_parmA,'String')),str2double(get(handles.edit_parmB,'String')),str2double(get(handles.edit_parmC,'String'))];
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

[handles.DATA_INITSPACING,~] = PlaneSpacings(initParms,type,getHKLs(type),keV2Angstrom(handles.ENERGY));
xrLatParmRefine_updatePlots(hObject,handles); 
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_parmB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_parmB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_parmC_Callback(hObject, eventdata, handles)
% hObject    handle to edit_parmC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_parmC as text
%        str2double(get(hObject,'String')) returns contents of edit_parmC as a double
handles.DATA_INITSPACING = [];
initParms = [str2double(get(handles.edit_parmA,'String')),str2double(get(handles.edit_parmB,'String')),str2double(get(handles.edit_parmC,'String'))];
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


[handles.DATA_INITSPACING,~] = PlaneSpacings(initParms,type,getHKLs(type),keV2Angstrom(handles.ENERGY));
xrLatParmRefine_updatePlots(hObject,handles); 
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_parmC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_parmC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_initspacing.
function checkbox_initspacing_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_initspacing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_initspacing
xrLatParmRefine_updatePlots(hObject,handles); 
guidata(hObject,handles);


function edit_energy_Callback(hObject, eventdata, handles)
% hObject    handle to edit_energy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_energy as text
%        str2double(get(hObject,'String')) returns contents of edit_energy as a double
handles.ENERGY = str2double(get(handles.edit_ebergy,'String'));
guidata(hObject,handles);

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


% --- Executes on button press in checkbox_width.
function checkbox_width_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_width
xrLatParmRefine_updatePlots(hObject,handles); 
guidata(hObject,handles);


% --------------------------------------------------------------------
function uitoggletool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uitoggletool1_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.checkbox_autoY,'Value',0);
set(handles.checkbox_autoX,'Value',0);
guidata(hObject,handles);


% --------------------------------------------------------------------
function uitoggletool1_OffCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ylim = get(handles.axes_plot,'YLim');
xlim = get(handles.axes_plot,'XLim');
set(handles.edit_YMin,'String',num2str(ylim(1)));
set(handles.edit_YMax,'String',num2str(ylim(2)));
set(handles.edit_XMin,'String',num2str(xlim(1)));
set(handles.edit_XMax,'String',num2str(xlim(2)));
guidata(hObject,handles)


% --------------------------------------------------------------------
function uitoggletool2_OffCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ylim = get(handles.axes_plot,'YLim');
xlim = get(handles.axes_plot,'XLim');
set(handles.edit_YMin,'String',num2str(ylim(1)));
set(handles.edit_YMax,'String',num2str(ylim(2)));
set(handles.edit_XMin,'String',num2str(xlim(1)));
set(handles.edit_XMax,'String',num2str(xlim(2)));
guidata(hObject,handles)

% --------------------------------------------------------------------
function uitoggletool2_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.checkbox_autoY,'Value',0);
set(handles.checkbox_autoX,'Value',0);
guidata(hObject,handles);


% --------------------------------------------------------------------
function uitoggletool3_OffCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ylim = get(handles.axes_plot,'YLim');
xlim = get(handles.axes_plot,'XLim');
set(handles.edit_YMin,'String',num2str(ylim(1)));
set(handles.edit_YMax,'String',num2str(ylim(2)));
set(handles.edit_XMin,'String',num2str(xlim(1)));
set(handles.edit_XMax,'String',num2str(xlim(2)));
guidata(hObject,handles)

% --------------------------------------------------------------------
function uitoggletool3_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.checkbox_autoY,'Value',0);
set(handles.checkbox_autoX,'Value',0);
guidata(hObject,handles);


% --- Executes when entered data in editable cell(s) in uitable_maxes.
function uitable_maxes_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable_maxes (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
cdata = get(handles.uitable_maxes,'Data');
disp(cdata)
widths = cell2mat(cdata(:,3));
handles.DATA_MAXES(:,3) = widths;
xrLatParmRefine_updatePlots(hObject,handles); 
guidata(hObject,handles);


% --- Executes on button press in checkbox_fits.
function checkbox_fits_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_fits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_fits
xrLatParmRefine_updatePlots(hObject,handles); 
guidata(hObject,handles);

% --- Executes on selection change in popupmenu_dist.
function popupmenu_dist_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_dist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_dist


% --- Executes during object creation, after setting all properties.
function popupmenu_dist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_calcParam.
function button_calcParam_Callback(hObject, eventdata, handles)
% hObject    handle to button_calcParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% for(i=1:size(handles.DATA_MAXES,1))
if(handles.loaded==1 && ~isempty(handles.DATA_MAXES))

    options = optimset('TolFun',1e-10,'Display','notify','MaxFunEvals',20000,'MaxIter',2000);
    handles.DATA_FIT = {};

    tt = get(handles.popupmenu_dist,'Value');
    switch(tt)
        case(1)
            type = 'pvoigt';
        case(2)
            type = 'gaussian';
        case(3)
            type = 'lorentz';
    end

    popval = get(handles.popupmenu_type,'Value');
    typeLatt = '';
    switch(popval)
        case(1)
            typeLatt = 'cubic';
        case(2)
            typeLatt = 'hexagonal';
        case(3)
            typeLatt = 'trigonal';
        case(4)
            typeLatt = 'tetragonal';
        case(5)
            typeLatt = 'orthorhombic';
        case(6)    
            typeLatt = 'monoclinic';
    end

    for(i=1:size(handles.DATA_MAXES,1))
        indice1 = length(find(handles.DATA_DSPACING > handles.DATA_MAXES(i,1)-handles.DATA_MAXES(i,3)/2));
        indice2 = length(find(handles.DATA_DSPACING > handles.DATA_MAXES(i,1)+handles.DATA_MAXES(i,3)/2));
        xDataT = handles.DATA_2THETA(indice2:indice1,1);
        xDataD = handles.DATA_DSPACING(indice2:indice1,1);
        yData = handles.DATA_INTENSITY(indice2:indice1,1);


        p0 = [abs(handles.DATA_MAXES(i,2))/12;...
            0.05;...
            handles.DATA_MAXES(i,3);... %width
            handles.DATA_MAXES(i,4);... %2thetas
            0;
            mean(yData)];

    %     p0 = [513726.373445702;...
    %             .0813;...
    %             .1539;...
    %             11.5327;...
    %             mean(yData)]
    %         
        [p, resnorm,resid,exitf]  = lsqcurvefit(@(p0,xDataT)pfunc(p0,xDataT,type), p0, xDataT, yData);

        handles.DATA_FIT{i,1}=xDataD;
        handles.DATA_FIT{i,2}=xDataT;
        handles.DATA_FIT{i,3}=pfunc(p, xDataT,type);        

        %tth_fit is the ideal 2theta (or d-spacing), the value which the
        %least squares reduction below tries to optimize to (using a, b, c
        %lattice parameters)
        
        tth_fit(1,i) = p(4);
        A_fit(1,i) = p(1);
        Resnorm_fit(1,i) = resnorm;

    %     disp(dspc_fit)
    end

    a0 = str2double(get(handles.edit_parmA,'String'));
    b0 = str2double(get(handles.edit_parmB,'String'));
    c0 = str2double(get(handles.edit_parmC,'String'));

    parms0 = [a0,b0,c0];
    hkls = [];
    for(i=1:size(handles.DATA_MAXES,1))
        tstring = num2str(handles.DATA_MAXES(i,5));
        hkls(i,:) = [str2double(tstring(1)),str2double(tstring(2)),str2double(tstring(3))];
    end

    disp(hkls)
    % disp(a0)

    a0out = [0 0 0];
    ff = @(x)LatParmResid2(x,tth_fit,keV2Angstrom(handles.ENERGY),hkls,typeLatt);
    [a0out,a0resid,iterflag] = lsqnonlin(ff,parms0,2,4,options);

    set(handles.text_parmA,'String',['a = ',num2str(a0out(1))]);
    set(handles.text_parmB,'String',['b = ',num2str(a0out(2))]);
    set(handles.text_parmC,'String',['c = ',num2str(a0out(3))]);
    set(handles.text_parmResid2,'String',num2str(a0resid));
    
    handles.lattice_params(handles.binNum,1)=a0out(1);
    handles.lattice_params(handles.binNum,2)=a0out(2);
    handles.lattice_params(handles.binNum,3)=a0out(3);
    
    assignin('base','a0resid',a0resid);

    filename = [handles.filename(1:end-4),'_LarParmRefine.mat'];
    disp(filename)

    %data to save to the parameter file



    set(handles.checkbox_fits,'Value',1);
    xrLatParmRefine_updatePlots(hObject,handles); 
end
guidata(hObject,handles)


% --- Executes on button press in button_binMinus.
function button_binMinus_Callback(hObject, eventdata, handles)
% hObject    handle to button_binMinus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.numBins == 0)
    set(handles.edit_binNum,'String','1');
else
    if(handles.binNum~=1)
        handles.binNum = handles.binNum-1;
        handles.DATA_INTENSITY = handles.binDATA(:,3*(handles.binNum-1)+1);    
        handles.DATA_2THETA = handles.binDATA(:,3*(handles.binNum-1)+2);
        handles.DATA_DSPACING = handles.binDATA(:,3*(handles.binNum-1)+3);
        set(handles.edit_binNum,'String',num2str(handles.binNum));
    end
end
xrLatParmRefine_updatePlots(hObject,handles);
guidata(hObject,handles);

% --- Executes on button press in button_binPlus.
function button_binPlus_Callback(hObject, eventdata, handles)
% hObject    handle to button_binPlus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(handles.numBins == 0)
    set(handles.edit_binNum,'String','1');
else
    if(handles.binNum~=handles.numBins)
        handles.binNum = handles.binNum+1;
        handles.DATA_INTENSITY = handles.binDATA(:,3*(handles.binNum-1)+1);    
        handles.DATA_2THETA = handles.binDATA(:,3*(handles.binNum-1)+2);
        handles.DATA_DSPACING = handles.binDATA(:,3*(handles.binNum-1)+3);
        set(handles.edit_binNum,'String',num2str(handles.binNum));
    end
end
xrLatParmRefine_updatePlots(hObject,handles);
guidata(hObject,handles);
