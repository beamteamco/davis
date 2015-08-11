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

% Last Modified by GUIDE v2.5 30-Jul-2015 18:58:09

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

handles.DATA_INITSPACING = [];
handles.numBins = 0;
handles.binNum = str2double(get(handles.edit_binNum,'String'));
handles.Override = 0;
handles.DATA_FIT = {};
handles.hkl_mask = [];
handles.maxParams = struct(...
    'Imin',0,...
    'Imax',3*10^4,...
    'SpacingMin',0.1);

handles.DATA = struct(...
    'intensity',{},...
    'dspacing',{},...
    'theta2',{},...
    'energy',[],...
    'maxes',{},...
    'a',[],...
    'b',[],...
    'c',[],...
    'resid',[],...
    'theta_fit',[],...
    'dspacing_fit',[],...
    'data_fit',{});

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
    
    handles.DATA = struct(...
    'intensity',cell(handles.numBins,1),...
    'dspacing',cell(handles.numBins,1),...
    'theta2',cell(handles.numBins,1),...
    'energy',cell2mat(x.binData(end,1)),...
    'maxes',cell(handles.numBins,1),...
    'a',[],...
    'b',[],...
    'c',[],...
    'resid',[],...
    'theta_fit',[],...
    'dspacing_fit',[],...
    'data_fit',cell(handles.numBins,1));

%     assignin('base','hdata',handles.DATA);
    disp(handles.numBins);
    handles.binNum = str2double(get(handles.edit_binNum,'String'));

    set(handles.text_numBins,'String',['# of bins = ',num2str(handles.numBins)]);
    
    handles.binDATA = cell2mat(x.binData(2:end-2,:));

    for(i=1:handles.numBins)
        handles.DATA(i).intensity = cell2mat(x.binData(2:end-2,3*(i-1)+1));
        handles.DATA(i).theta2 = cell2mat(x.binData(2:end-2,3*(i-1)+2));
        handles.DATA(i).dspacing = cell2mat(x.binData(2:end-2,3*(i-1)+3));
    end
%     assignin('base','hdata2',handles.DATA);
    handles.DATA_INTENSITY = cell2mat(x.binData(2:end-2,3*(handles.binNum-1)+1));    
    handles.DATA_2THETA = cell2mat(x.binData(2:end-2,3*(handles.binNum-1)+2));
    handles.DATA_DSPACING = cell2mat(x.binData(2:end-2,3*(handles.binNum-1)+3));
    handles.ENERGY = cell2mat(x.binData(end,1));
%     disp(handles.ENERGY);
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

    handles.maxParams.Imin = 0.15*max(handles.DATA_INTENSITY);
    handles.maxParams.Imax = max(handles.DATA_INTENSITY);
    handles.maxParams.SpacingMin = 0.1;

    disp('Data Loaded\n')
    set(handles.label_filepath,'String',['Input Filepath: ',tempFilename]);
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
    return
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

%updates the max values based on stored data
handles.DATA_MAXES = handles.DATA(handles.binNum).maxes;
if(~isempty(handles.DATA_MAXES))
    set(handles.uitable_maxes,'Data',[num2cell(handles.DATA_MAXES(:,1)),num2cell(handles.DATA_MAXES(:,2)),num2cell(handles.DATA_MAXES(:,3)),num2cell(handles.DATA_MAXES(:,5))]);
else
    set(handles.uitable_maxes,'Data',{});
end

handles.DATA_FIT = handles.DATA(handles.binNum).data_fit;

set(handles.text_maxnum,'String',['Max # = ',num2str(size(handles.DATA_MAXES,1))]);  
set(handles.text_parmA,'String',['a = ',num2str(handles.DATA(handles.binNum).a)]);
set(handles.text_parmB,'String',['b = ',num2str(handles.DATA(handles.binNum).b)]);
set(handles.text_parmC,'String',['c = ',num2str(handles.DATA(handles.binNum).c)]);
set(handles.text_parmResid2,'String',num2str(handles.DATA(handles.binNum).resid));

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
    pass = 0;
    
    disp('Maximum Calculation Parameters');
    disp(handles.maxParams);

    h=6.626*10^-34;
    c=3*10^8;
    e=1.602*10^-19;
    lambda = h * c / ( 1000 * handles.ENERGY * e );
    
    
    %Redo indexperspace, nonlinaer relationship
    indexPerSpace = length(handles.DATA_DSPACING)/abs(handles.DATA_2THETA(1)-handles.DATA_2THETA(end));
    disp(['indexperspace = ',num2str(indexPerSpace)])
    
    for(i=2:length(handles.DATA_DSPACING)-1)        
        if((handles.DATA_INTENSITY(i) >= handles.maxParams.Imin) &&...
                (handles.DATA_INTENSITY(i) <= handles.maxParams.Imax) &&...
                (handles.DATA_INTENSITY(i) > handles.DATA_INTENSITY(i-1)) &&...
                (handles.DATA_INTENSITY(i) > handles.DATA_INTENSITY(i+1)))
            
            iLeft = floor(indexPerSpace*2*180*asin((lambda*(1e10))/(2*(handles.DATA_DSPACING(i)+handles.maxParams.SpacingMin)))/pi());
            iRight = floor(indexPerSpace*2*180*asin((lambda*(1e10))/(2*(handles.DATA_DSPACING(i)-handles.maxParams.SpacingMin)))/pi());
            
            if(iRight>length(handles.DATA_INTENSITY))
                iRight=length(handles.DATA_INTENSITY);
            end
            if(iLeft<1)
                iLeft=1;
            end
            
            for(j=iLeft:iRight)
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
    
    disp('Maximum Calculation Complete')
    set(handles.text_maxnum,'String',['Max # = ',num2str(size(handles.DATA_MAXES,1))]);       
    
    handles.DATA(handles.binNum).maxes = handles.DATA_MAXES;
    
    xrLatParmRefine_updatePlots(hObject,handles);
else
    msgbox('Please load data before calculations');
end
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
    
    handles.DATA(handles.binNum).maxes = handles.DATA_MAXES;
    
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
%     options2 = optimset('Di);
    
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

        assignin('base','xdata',xDataT);
        assignin('base','ydata',yData);
        
        disp(indice2);

        p0 = [abs(handles.DATA_MAXES(i,2))/12;...
            0.05;...
            handles.DATA_MAXES(i,3);... %width
            handles.DATA_MAXES(i,4);... %2thetas
            0;
            mean(yData)];

        assignin('base','p0',p0);
    %     p0 = [513726.373445702;...
    %             .0813;...
    %             .1539;...
    %             11.5327;...
    %             mean(yData)]
    %         
        [p, resnorm,resid,exitf]  = lsqcurvefit(@(p0,xDataT)pfunc(p0,xDataT,type), p0, xDataT, yData,[0,0,0,0,0,0],[Inf,Inf,Inf,Inf,Inf,Inf]);

        handles.DATA_FIT{i,1}=xDataD;
        handles.DATA_FIT{i,2}=xDataT;
        handles.DATA_FIT{i,3}=pfunc(p, xDataT,type);        

        %tth_fit is the 2theta for the given peak distribution fit
        
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
    ff = @(x)LatParmResid(x,tth_fit,keV2Angstrom(handles.ENERGY),hkls,typeLatt);
    [a0out,a0resid,iterflag] = lsqnonlin(ff,parms0(1),2,4,options);
    a0out(2:3)=0;
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


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %saves and shows the total output data
    handles.DATA(handles.binNum).maxes = handles.DATA_MAXES;
    handles.DATA(handles.binNum).a = a0out(1);
    handles.DATA(handles.binNum).b = a0out(2);
    handles.DATA(handles.binNum).c = a0out(3);
    handles.DATA(handles.binNum).theta_fit = tth_fit;
    handles.DATA(handles.binNum).data_fit = handles.DATA_FIT;
    handles.DATA(handles.binNum).resid = a0resid;
    
    assignin('base','DATA',handles.DATA)
    
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
    return
else
    if(handles.binNum~=1)
        handles.binNum = handles.binNum-1;
        handles.DATA_INTENSITY = handles.binDATA(:,3*(handles.binNum-1)+1);    
        handles.DATA_2THETA = handles.binDATA(:,3*(handles.binNum-1)+2);
        handles.DATA_DSPACING = handles.binDATA(:,3*(handles.binNum-1)+3);
        set(handles.edit_binNum,'String',num2str(handles.binNum));
    end
end

handles.maxParams.Imax = max(handles.DATA_INTENSITY);
handles.maxParams.Imin = 0.65*max(handles.DATA_INTENSITY);
handles.maxParams.SpacingMin = 0.1;

%updates the max values based on stored data
handles.DATA_MAXES = handles.DATA(handles.binNum).maxes;
if(~isempty(handles.DATA_MAXES))
    set(handles.uitable_maxes,'Data',[num2cell(handles.DATA_MAXES(:,1)),num2cell(handles.DATA_MAXES(:,2)),num2cell(handles.DATA_MAXES(:,3)),num2cell(handles.DATA_MAXES(:,5))]);
else
    set(handles.uitable_maxes,'Data',{});
end

%updates fit data
handles.DATA_FIT = handles.DATA(handles.binNum).data_fit;

set(handles.text_maxnum,'String',['Max # = ',num2str(size(handles.DATA_MAXES,1))]);  
set(handles.text_parmA,'String',['a = ',num2str(handles.DATA(handles.binNum).a)]);
set(handles.text_parmB,'String',['b = ',num2str(handles.DATA(handles.binNum).b)]);
set(handles.text_parmC,'String',['c = ',num2str(handles.DATA(handles.binNum).c)]);
set(handles.text_parmResid2,'String',num2str(handles.DATA(handles.binNum).resid));

xrLatParmRefine_updatePlots(hObject,handles);
guidata(hObject,handles);

% --- Executes on button press in button_binPlus.
function button_binPlus_Callback(hObject, eventdata, handles)
% hObject    handle to button_binPlus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(handles.numBins == 0)
    set(handles.edit_binNum,'String','1');
    return
else
    if(handles.binNum~=handles.numBins)
        handles.binNum = handles.binNum+1;
        handles.DATA_INTENSITY = handles.binDATA(:,3*(handles.binNum-1)+1);    
        handles.DATA_2THETA = handles.binDATA(:,3*(handles.binNum-1)+2);
        handles.DATA_DSPACING = handles.binDATA(:,3*(handles.binNum-1)+3);
        set(handles.edit_binNum,'String',num2str(handles.binNum));
    end
end

handles.maxParams.Imax = max(handles.DATA_INTENSITY);
handles.maxParams.Imin = 0.65*max(handles.DATA_INTENSITY);
handles.maxParams.SpacingMin = 0.1;

%updates the max values based on stored data
handles.DATA_MAXES = handles.DATA(handles.binNum).maxes;
if(~isempty(handles.DATA_MAXES))
    set(handles.uitable_maxes,'Data',[num2cell(handles.DATA_MAXES(:,1)),num2cell(handles.DATA_MAXES(:,2)),num2cell(handles.DATA_MAXES(:,3)),num2cell(handles.DATA_MAXES(:,5))]);
else
    set(handles.uitable_maxes,'Data',{});
end

handles.DATA_FIT = handles.DATA(handles.binNum).data_fit;

set(handles.text_maxnum,'String',['Max # = ',num2str(size(handles.DATA_MAXES,1))]);  
set(handles.text_parmA,'String',['a = ',num2str(handles.DATA(handles.binNum).a)]);
set(handles.text_parmB,'String',['b = ',num2str(handles.DATA(handles.binNum).b)]);
set(handles.text_parmC,'String',['c = ',num2str(handles.DATA(handles.binNum).c)]);
set(handles.text_parmResid2,'String',num2str(handles.DATA(handles.binNum).resid));
    
xrLatParmRefine_updatePlots(hObject,handles);
guidata(hObject,handles);


% --- Executes on button press in button_calcparms.
function button_calcparms_Callback(hObject, eventdata, handles)
% hObject    handle to button_calcparms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% handles.maxParams = struct(...
%     'Imin',0,...
%     'Imax',3*10^4,...
%     'SpacingMin',0.1);

prompt = {'Intensity Maximum (leave blank for max value over entire function',...
    'Intensity Minimum (leave blank for auto 25% of max',...
    'Min Distance from Next Maximum (if two peaks are within the distance, chooses the peak with the larger value)'};

title = 'Edit Calculation Parameters';
def = {num2str(handles.maxParams.Imax),num2str(handles.maxParams.Imin),num2str(handles.maxParams.SpacingMin)};

answer = inputdlg(prompt,title,1,def);

if(~isempty(answer))
    if(isempty(answer{1}))
        handles.maxParams.Imax = max(handles.DATA_INTENSITY);
    else
        handles.maxParams.Imax = str2double(answer{1});
    end
    
    if(isempty(answer{2}))
        handles.maxParams.Imin = 0.15*max(handles.DATA_INTENSITY);
    else
        handles.maxParams.Imin = str2double(answer{2});
    end
    
    if(~isempty(answer{3}))
        handles.maxParams.SpacingMin = str2double(answer{3});
    end
    
    disp(handles.maxParams);
end

guidata(hObject,handles)


% --------------------------------------------------------------------
function menu_File_Callback(hObject, eventdata, handles)
% hObject    handle to menu_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_saveRefine_Callback(hObject, eventdata, handles)
% hObject    handle to menu_saveRefine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[t1,t2] = uiputfile('*.mat','Save Output Data');

if(ischar(t1) && handles.loaded==1)
    refinement_data = handles.DATA;
    save([t2,t1],'refinement_data');
    disp(['File ',t2,t1,' Saved Successfully']);
end


% --------------------------------------------------------------------
function menu_exit_Callback(hObject, eventdata, handles)
% hObject    handle to menu_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close();


% --------------------------------------------------------------------
function menu_calcs_Callback(hObject, eventdata, handles)
% hObject    handle to menu_calcs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_calcmaxes_Callback(hObject, eventdata, handles)
% hObject    handle to menu_calcmaxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(handles.loaded==0)
    return
end

temp = handles.binNum;

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

s=sprintf('Lattice Type = %s\n\nhkl''s=\n\n',type);
for(jj=1:size(hkls,2))
    s = [s,sprintf('%d%d%d\n',hkls(1,jj),hkls(2,jj),hkls(3,jj))];
end
s = [s,sprintf('\nType in the hkls considered for max finding as csv (eg 100,101,200)')];
prompt = {s};

if(handles.Override == 0)
    title = 'Choose hkl''s for Max Finding';
    def = {'100,110,200,211'};

    answer = inputdlg(prompt,title,1,def);

    inputHkls = str2num(answer{1});

    hkl_mask = zeros(1,size(hkls,2));

    for(i=1:length(inputHkls))
        for(jj=1:size(hkls,2))
            if(inputHkls(i)==str2double([num2str(hkls(1,jj)),num2str(hkls(2,jj)),num2str(hkls(3,jj))]))
                hkl_mask(jj)=1;
            end
        end
    end
%     disp(hkl_mask);
else
    hkl_mask = handles.hkl_mask;
end

tic
for(i=1:handles.numBins)
    handles.binNum = i;

    handles.DATA_INTENSITY = handles.binDATA(:,3*(handles.binNum-1)+1);    
    handles.DATA_2THETA = handles.binDATA(:,3*(handles.binNum-1)+2);
    handles.DATA_DSPACING = handles.binDATA(:,3*(handles.binNum-1)+3);
    set(handles.edit_binNum,'String',num2str(handles.binNum));


    handles.maxParams.Imax = max(handles.DATA_INTENSITY);
    handles.maxParams.Imin = 0.65*max(handles.DATA_INTENSITY);
    handles.maxParams.SpacingMin = 0.1;

    %updates the max values based on stored data
    handles.DATA_MAXES = handles.DATA(handles.binNum).maxes;
    if(~isempty(handles.DATA_MAXES))
        set(handles.uitable_maxes,'Data',[num2cell(handles.DATA_MAXES(:,1)),num2cell(handles.DATA_MAXES(:,2)),num2cell(handles.DATA_MAXES(:,3)),num2cell(handles.DATA_MAXES(:,5))]);
    else
        set(handles.uitable_maxes,'Data',{});
    end

    handles.DATA_FIT = handles.DATA(handles.binNum).data_fit;       

    if(handles.loaded==1)
        z=1;
        handles.DATA_MAXES = [,];
        pass = 0;

%         disp('Maximum Calculation Parameters');
%         disp(handles.maxParams);

        h=6.626*10^-34;
        c=3*10^8;
        e=1.602*10^-19;
        lambda = h * c / ( 1000 * handles.ENERGY * e );


        %Redo indexperspace, nonlinaer relationship
        indexPerSpace = length(handles.DATA_DSPACING)/abs(handles.DATA_2THETA(1)-handles.DATA_2THETA(end));
%         disp(['indexperspace = ',num2str(indexPerSpace)])

        %finds all local maximums, check to see if there is another within
        %mindistance, if so chooses the largest of them
% %         for(i=2:length(handles.DATA_DSPACING)-1)        
% %             if((handles.DATA_INTENSITY(i) >= handles.maxParams.Imin) &&...
% %                     (handles.DATA_INTENSITY(i) <= handles.maxParams.Imax) &&...
% %                     (handles.DATA_INTENSITY(i) > handles.DATA_INTENSITY(i-1)) &&...
% %                     (handles.DATA_INTENSITY(i) > handles.DATA_INTENSITY(i+1)))
% % 
% %                 iLeft = floor(indexPerSpace*2*180*asin((lambda*(1e10))/(2*(handles.DATA_DSPACING(i)+handles.maxParams.SpacingMin)))/pi());
% %                 iRight = floor(indexPerSpace*2*180*asin((lambda*(1e10))/(2*(handles.DATA_DSPACING(i)-handles.maxParams.SpacingMin)))/pi());
% % 
% %                 if(iRight>length(handles.DATA_INTENSITY))
% %                     iRight=length(handles.DATA_INTENSITY);
% %                 end
% %                 if(iLeft<1)
% %                     iLeft=1;
% %                 end
% % 
% %                 for(j=iLeft:iRight)
% %                     if(handles.DATA_INTENSITY(i) >= handles.DATA_INTENSITY(j))
% %                         pass=1;
% %                     else
% %                         pass=0;
% %                         break;
% %                     end
% %                 end
% % 
% %                 if(pass==1)
% %                     indexx=1;
% %                     handles.DATA_MAXES(z,1:2) = [handles.DATA_DSPACING(i),handles.DATA_INTENSITY(i)];
% %                     handles.DATA_MAXES(z,3) = 0.25; 
% %                     handles.DATA_MAXES(z,4) = handles.DATA_2THETA(i);
% %                     for(k=1:length(handles.DATA_INITSPACING))
% %                         if(abs(handles.DATA_DSPACING(i)-handles.DATA_INITSPACING(k))<abs(handles.DATA_DSPACING(i)-handles.DATA_INITSPACING(indexx)))
% %                             indexx = k;
% %                         end                
% %                     end
% %                     handles.DATA_MAXES(z,5) = str2double([num2str(hkls(1,indexx)),num2str(hkls(2,indexx)),num2str(hkls(3,indexx))]);
% %                     z=z+1;
% %                 end 
% % 
% %             end    
% %         end

        %new peak finding algorithm, looks within a certain range of the
        %inital hkl spacings, chooses the max within that range as the
        %vlaue for that specific hkl
        
        %only choosing the first 4 hkls, can be changed
        
        ct1=1;
        for(ii=1:size(hkls,2))  
            if(hkl_mask(ii)==1)
                for(j=1:length(handles.DATA_INTENSITY))
                    if(handles.DATA_DSPACING(j) < handles.DATA_INITSPACING(ii)+handles.maxParams.SpacingMin)
                        iLeft = j;
                        break
                    else
                        iLeft = j;
                    end
                end
                for(j=iLeft:length(handles.DATA_INTENSITY))
                    if(handles.DATA_DSPACING(j) < handles.DATA_INITSPACING(ii)-handles.maxParams.SpacingMin)
                        iRight = j;
                        break
                    else
                        iRight = j;
                    end
                end
    %             iLeft = find(handles.DATA_DSPACING>handles.DATA_INITSPACING(i)+handles.maxParams.SpacingMin);
    %             iRight = find(handles.DATA_DSPACING<handles.DATA_INITSPACING(i)-handles.maxParams.SpacingMin);

                if(iRight>length(handles.DATA_INTENSITY))
                    iRight=length(handles.DATA_INTENSITY);
                end
                if(iLeft<1)
                    iLeft=1;
                end

    %             disp(sprintf('iLeft for #%d is %d, dspace=%d',i,iLeft,handles.DATA_DSPACING(iLeft)));
    %             disp(sprintf('iRight for #%d is %d, dspace=%d',i,iRight,handles.DATA_DSPACING(iRight)));
                for(j=iLeft+1:iRight-1)
                    if(j==iLeft+1)
                        maxIndex = j;
                    end
                    if(handles.DATA_INTENSITY(j) > handles.DATA_INTENSITY(maxIndex))
                        maxIndex = j;
                    end
                    handles.DATA_MAXES(ct1,1:2) = [handles.DATA_DSPACING(maxIndex),handles.DATA_INTENSITY(maxIndex)];
                    handles.DATA_MAXES(ct1,3) = 0.15; 
                    handles.DATA_MAXES(ct1,4) = handles.DATA_2THETA(maxIndex);
                    handles.DATA_MAXES(ct1,5) = str2double([num2str(hkls(1,ii)),num2str(hkls(2,ii)),num2str(hkls(3,ii))]);
                end
                ct1=ct1+1;
            end
        end
        
        %sorts the maxes in order of d-spacing
        handles.DATA_MAXES = orderSort(handles.DATA_MAXES,'a',1);
        if(~isempty(handles.DATA_MAXES))
            set(handles.uitable_maxes,'Data',[num2cell(handles.DATA_MAXES(:,1)),num2cell(handles.DATA_MAXES(:,2)),num2cell(handles.DATA_MAXES(:,3)),num2cell(handles.DATA_MAXES(:,5))]);
        else
            set(handles.uitable_maxes,'Data',{});
        end

        disp(sprintf('Maximum Calculation Complete for Bin #%d',i));
        set(handles.text_maxnum,'String',['Max # = ',num2str(size(handles.DATA_MAXES,1))]);       

        handles.DATA(handles.binNum).maxes = handles.DATA_MAXES;

        xrLatParmRefine_updatePlots(hObject,handles);
    else
        msgbox('Please load data before calculations');
    end
end
disp(sprintf('Elapsed Time = %5.2fs',toc));

handles.binNum = temp;

handles.DATA_INTENSITY = handles.binDATA(:,3*(handles.binNum-1)+1);    
handles.DATA_2THETA = handles.binDATA(:,3*(handles.binNum-1)+2);
handles.DATA_DSPACING = handles.binDATA(:,3*(handles.binNum-1)+3);
set(handles.edit_binNum,'String',num2str(handles.binNum));

handles.maxParams.Imax = max(handles.DATA_INTENSITY);
handles.maxParams.Imin = 0.15*max(handles.DATA_INTENSITY);
handles.maxParams.SpacingMin = 0.1;
  

%updates the max values based on stored data
handles.DATA_MAXES = handles.DATA(handles.binNum).maxes;
if(~isempty(handles.DATA_MAXES))
    set(handles.uitable_maxes,'Data',[num2cell(handles.DATA_MAXES(:,1)),num2cell(handles.DATA_MAXES(:,2)),num2cell(handles.DATA_MAXES(:,3)),num2cell(handles.DATA_MAXES(:,5))]);
else
    set(handles.uitable_maxes,'Data',{});
end

handles.DATA_FIT = handles.DATA(handles.binNum).data_fit;

set(handles.text_maxnum,'String',['Max # = ',num2str(size(handles.DATA_MAXES,1))]);  
set(handles.text_parmA,'String',['a = ',num2str(handles.DATA(handles.binNum).a)]);
set(handles.text_parmB,'String',['b = ',num2str(handles.DATA(handles.binNum).b)]);
set(handles.text_parmC,'String',['c = ',num2str(handles.DATA(handles.binNum).c)]);
set(handles.text_parmResid2,'String',num2str(handles.DATA(handles.binNum).resid));

xrLatParmRefine_updatePlots(hObject,handles);
guidata(hObject,handles);

% --------------------------------------------------------------------
function menu_calcfitparams_Callback(hObject, eventdata, handles)
% hObject    handle to menu_calcfitparams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(handles.loaded==0)
    return
end
for(i=1:handles.numBins)
    if(isempty(handles.DATA(i).maxes))
        return
    end
end

options = optimset('TolFun',1e-10,'Display','notify','MaxFunEvals',20000,'MaxIter',2000,'Display','off');
options2 = optimset('Display','off');
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
    
if(handles.loaded==1 && ~isempty(handles.DATA_MAXES))
    
    temp = handles.binNum;
    for(ii=1:handles.numBins)     
        assignin('base','binNum',ii)
        handles.binNum = ii;
        
        handles.DATA_INTENSITY = handles.binDATA(:,3*(handles.binNum-1)+1);    
        handles.DATA_2THETA = handles.binDATA(:,3*(handles.binNum-1)+2);
        handles.DATA_DSPACING = handles.binDATA(:,3*(handles.binNum-1)+3);
        handles.DATA_MAXES = handles.DATA(handles.binNum).maxes;

        handles.DATA_FIT = {};

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
            [p, resnorm,resid,exitf]  = lsqcurvefit(@(p0,xDataT)pfunc(p0,xDataT,type), p0, xDataT, yData,[0,0,0,0,0,0],[Inf,Inf,Inf,Inf,Inf,Inf],options2);

            handles.DATA_FIT{i,1}=xDataD;
            handles.DATA_FIT{i,2}=xDataT;
            handles.DATA_FIT{i,3}=pfunc(p, xDataT,type);        

            %tth_fit is the 2theta for the given peak distribution fit

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

%         disp(hkls)
        % disp(a0)

        a0out = [0 0 0];
        ff = @(x)LatParmResid(x,tth_fit,keV2Angstrom(handles.ENERGY),hkls,typeLatt);
        [a0out,a0resid,iterflag] = lsqnonlin(ff,parms0(1),2,4,options);     % using first param for cubic, lsq algorithm requires 
                                                                            % equation for every variable (a,b,c) even if unused
        a0out(2:3)=0; % fix related to above (for cubic)
        
        handles.lattice_params(handles.binNum,1)=a0out(1);
        handles.lattice_params(handles.binNum,2)=a0out(2);
        handles.lattice_params(handles.binNum,3)=a0out(3);

        assignin('base','a0resid',a0resid);

        filename = [handles.filename(1:end-4),'_LarParmRefine.mat'];
        disp(sprintf('Fit and Parameter Refinement Complete for Bin #%d Complete',ii));

        %data to save to the parameter file


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %saves and shows the total output data
        handles.DATA(handles.binNum).a = a0out(1);
        handles.DATA(handles.binNum).b = a0out(2);
        handles.DATA(handles.binNum).c = a0out(3);
        handles.DATA(handles.binNum).theta_fit = tth_fit;
        handles.DATA(handles.binNum).data_fit = handles.DATA_FIT;
        handles.DATA(handles.binNum).resid = a0resid;   
    
    end
end

handles.binNum = temp;

handles.DATA_INTENSITY = handles.binDATA(:,3*(handles.binNum-1)+1);    
handles.DATA_2THETA = handles.binDATA(:,3*(handles.binNum-1)+2);
handles.DATA_DSPACING = handles.binDATA(:,3*(handles.binNum-1)+3);
set(handles.edit_binNum,'String',num2str(handles.binNum));

handles.maxParams.Imax = max(handles.DATA_INTENSITY);
handles.maxParams.Imin = 0.15*max(handles.DATA_INTENSITY);
handles.maxParams.SpacingMin = 0.1;

set(handles.checkbox_fits,'Value',1);
xrLatParmRefine_updatePlots(hObject,handles); 
assignin('base','DATA',handles.DATA)
guidata(hObject,handles)


% --------------------------------------------------------------------
function menu_loadrefine_Callback(hObject, eventdata, handles)
% hObject    handle to menu_loadrefine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.loaded==0)
    msgbox('Load bin data before refinement parameters');
    return
end

[t1,t2] = uigetfile('*.mat','Select Refinement .mat File');

if(~ischar(t1))
    return
end

inputData = load([t2,t1]);
if(length(inputData.refinement_data(1).intensity) == length(handles.DATA_INTENSITY) && size(inputData.refinement_data,1) == handles.numBins)
    handles.DATA = inputData.refinement_data;
else
    msgbox('Invalid Refinement File (# number of bins or data points do not match)')
end
disp('Data Loaded');
guidata(hObject,handles);


% --------------------------------------------------------------------
function menu_analysis_Callback(hObject, eventdata, handles)
% hObject    handle to menu_analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_strainpole_Callback(hObject, eventdata, handles)
% hObject    handle to menu_strainpole (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

waitfor(msgbox('Select the reference refinement data'));

[t1,t2] = uigetfile('*.mat','Choose reference refinement data');

if(~ischar(t1))
    return
end

reference_refinement = load([t2,'\',t1]);
if(size(reference_refinement.refinement_data,1)>1)
    waitfor(msgbox('More than one set of data detected, please choose different refinement data'));
    return
end

hkls = zeros(3,length(reference_refinement.refinement_data(1).theta_fit));
theta0_Ifits = reference_refinement.refinement_data(1).theta_fit; %using
% different method, instead of the fitted thetas, using the overall fitted
% lattice parameter and using the plane spacing equation with the parameter
% to get the thetas for the hkls

for(i=1:size(hkls,2))
    temp = num2str(reference_refinement.refinement_data(1).maxes(i,5));
    hkls(:,i) = [str2double(temp(1));str2double(temp(2));str2double(temp(3))];
    %note hkls ordered highest to lowest (eg 211 to 100) due to refinement
    %data format. It matches theta values from refinement data read in
    %order.
end
assignin('base','hkls',hkls);

s=sprintf('Reference Refinement Info\n# of Hkls = %d\n\nTheta Fits:\n',size(hkls,2));
for(i=1:size(hkls,2))
    s = [s,sprintf('(%d,%d,%d) = %7.4f°\n',hkls(1,i),hkls(2,i),hkls(3,i),theta0_Ifits(i))];
end
waitfor(msgbox(s));
waitfor(msgbox('Select the refinement data for each image'));


[t1,t2] = uigetfile('*.mat','Choose reference refinement data','Multiselect','On');

if(isempty(t1))
    return
end

theta_fits=[];
imageCount = length(t1);
binCount = 0;
for(i=1:length(t1))
    t = load([t2,t1{i}]);
    disp(['Loaded ',[t2,t1{i}]]);
    if(i==1)
        theta_fits = zeros(size(t.refinement_data,1),size(hkls,2),length(t1));
        binCount = size(t.refinement_data,1);
    end
    for(j=1:size(hkls,2))
        for(k=1:size(t.refinement_data,1))
            theta_fits(k,j,i) = t.refinement_data(k).theta_fit(j);
        end
    end
end

assignin('base','theta_fits',theta_fits);
waitfor(msgbox(sprintf('Number of image refinement data loaded: %d\nNumber of Bins per Image: %d',imageCount,binCount)));

%strain calculations for all images

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
    
handles.ENERGY = reference_refinement.refinement_data(1).energy;
[~,thetas0] = PlaneSpacings(reference_refinement.refinement_data(1).a,type,hkls,keV2Angstrom(handles.ENERGY));
% the initParms in the example code are predefined. Operating under the
% assumption that it represents the a0 value found from fitting (averaged, summed etc.)

%note thetas0, not bragg angle, need to multiply by 2
thetas0=thetas0*2;
assignin('base','thetas0',thetas0);
% for(i=1:length(t1))
%     for(j=1:size(t.refinement_data,1))
%             for(l=1:size(hkls,2))
%                 denom = sind(theta_fits(i,l,j)./2);
%                 if(denom==0)
%                     strains(i,l,j) = Inf;
%                 else
%                     strains(i,l,j) = sind(thetas0(l)./2)./denom - 1;
%                 end
%             end
%     end
% end

strains = zeros(size(theta_fits));

for(i=1:length(t1))
    for(j=1:size(hkls,2))
        for(k=1:size(t.refinement_data,1))
            denom = sind(theta_fits(k,j,i)./2);
            if(denom==0)
                strains(k,j,i) = Inf;
            else
                strains(k,j,i) = sind(thetas0(j)./2)./denom - 1;
            end
        end
    end
end
assignin('base','strains',strains);

%These parameters need to be accounted for
eta = 0:360/binCount:360-360/binCount;

%ome = -62.5:5:62.5; %test ome, has 26 5-degree intervals, (28 image set with 2 darks images)

titlep = 'Choose Omega Range';
prompt = {'Omega Upper Limit','Omega Lower Limit'};
def = {'62.5','-62.5'};
answer = inputdlg(prompt,titlep,1,def);

ome = str2double(answer{2}):(str2double(answer{1})-str2double(answer{2}))/(length(t1)-1):str2double(answer{1});
% # of refinemnt files read (one for each iamge) needs to correspond to
% each omega inteval. Checks for that and displays mismatch
if(length(t1)~=length(ome))
    disp('Data Mismatch. Not enough image refinmenet data to correspond to chosen omgea intervals');
end

%generates the scatter vectors for each hkl (based off of the reference
%hkls)

%generates scatterign vectors for sp figure
scVectors = {};

for(i=1:size(hkls,2))
    scVectors(i) = {GeneratePFScattVectors(thetas0(i),ome,eta)};
end
assignin('base','scatters',scVectors);



%creates the strains formatted for the PlotSPF function. This is
%accomplished by concatenating the strains into one long column vector. The
%spf strains are stored in a cell array, each cell hold the set of spf
%strains for each hkl

strains_spf = {};
% for(i=1:size(hkls,2))
%     for(j=1:length(t1))
%         if(j==1)
%         	strains_spf(i) = {reshape(strains(j,i,:),1,size(strains,3))'};
%         else
%             strains_spf(i) = {[strains_spf{i};reshape(strains(j,i,:),1,size(strains,3))']};
%         end
%     end
% end
for(i=1:size(hkls,2))
    for(j=1:length(t1))
        if(j==1)
        	strains_spf(i) = {strains(:,i,j)};
        else
            strains_spf(i) = {[strains_spf{i};strains(:,i,j)]};
        end
    end
end
assignin('base','strains_spf',strains_spf);

%test plot, needs more data first
for(i=1:size(hkls,2))
    figure
    PlotSPF(scVectors{1}',strains_spf{1});
    title(sprintf('SPF - (%d,%d,%d)',hkls(1,i),hkls(2,i),hkls(3,i)));
end


% --------------------------------------------------------------------
function menu_batchcalc_Callback(hObject, eventdata, handles)
% hObject    handle to menu_batchcalc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[t1,t2] = uigetfile('*.mat','Select Image Bin Data Files','Multiselect','On');

if(isempty(t1))
    return
end


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
    
%PREPARES HKL DATA FOR PEAK FINDING
hkls = getHKLs(type);
    
s=sprintf('Lattice Type = %s\n\nhkl''s=\n\n',type);
for(jj=1:size(hkls,2))
    s = [s,sprintf('%d%d%d\n',hkls(1,jj),hkls(2,jj),hkls(3,jj))];
end
s = [s,sprintf('\nType in the hkls considered for max finding as csv (eg 100,101,200)')];
prompt = {s};

title = 'Choose hkl''s for Max Finding';
def = {'100,110,200,211'};
answer = inputdlg(prompt,title,1,def);

inputHkls = str2num(answer{1});

handles.hkl_mask = zeros(1,size(hkls,2));

for(i=1:length(inputHkls))
    for(jj=1:size(hkls,2))
        if(inputHkls(i)==str2double([num2str(hkls(1,jj)),num2str(hkls(2,jj)),num2str(hkls(3,jj))]))
            handles.hkl_mask(jj)=1;
        end
    end
end 
    
%ASKS FOR FILE STEM FOR SAVING REFINEMENT DATA FILES
prompt = {'Choose File Stem'};
def = {'refinementData_'};
answer = inputdlg(prompt,title,1,def);

filestem = answer{1};

%PERFORMS PEAK FINDING AND FITTING FOR EACH DATA FILE
tprogress = 0;
hbar = waitbar(tprogress,'');
set(hbar,'WindowStyle','modal');
for(ttt=1:length(t1))
    waitbar(tprogress,hbar,sprintf('Processing Bin Data for Image #%d',ttt));
    %LOADS THE FILE DATA
    tempFilename = [t2,t1{ttt}];        
    x = load(tempFilename);

    set(handles.label_filepath,'String',['Input Filepath: ',tempFilename]);
    set(handles.edit_filename,'String',tempFilename);
    set(handles.edit_binNum,'String','1');
    
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
    
    handles.DATA = struct(...
    'intensity',cell(handles.numBins,1),...
    'dspacing',cell(handles.numBins,1),...
    'theta2',cell(handles.numBins,1),...
    'energy',cell2mat(x.binData(end,1)),...
    'maxes',cell(handles.numBins,1),...
    'a',[],...
    'b',[],...
    'c',[],...
    'resid',[],...
    'theta_fit',[],...
    'dspacing_fit',[],...
    'data_fit',cell(handles.numBins,1));

%     assignin('base','hdata',handles.DATA);
    disp(handles.numBins);
    handles.binNum = str2double(get(handles.edit_binNum,'String'));

    set(handles.text_numBins,'String',['# of bins = ',num2str(handles.numBins)]);
    
    handles.binDATA = cell2mat(x.binData(2:end-2,:));

    for(i=1:handles.numBins)
        handles.DATA(i).intensity = cell2mat(x.binData(2:end-2,3*(i-1)+1));
        handles.DATA(i).theta2 = cell2mat(x.binData(2:end-2,3*(i-1)+2));
        handles.DATA(i).dspacing = cell2mat(x.binData(2:end-2,3*(i-1)+3));
    end
%     assignin('base','hdata2',handles.DATA);
    handles.DATA_INTENSITY = cell2mat(x.binData(2:end-2,3*(handles.binNum-1)+1));    
    handles.DATA_2THETA = cell2mat(x.binData(2:end-2,3*(handles.binNum-1)+2));
    handles.DATA_DSPACING = cell2mat(x.binData(2:end-2,3*(handles.binNum-1)+3));
    handles.ENERGY = cell2mat(x.binData(end,1));
%     disp(handles.ENERGY);
    set(handles.edit_energy,'String',num2str(handles.ENERGY));
    handles.loaded = 1;
    
    handles.DATA_INITSPACING = [];    

    [handles.DATA_INITSPACING,~] = PlaneSpacings(initParms,type,getHKLs(type),keV2Angstrom(handles.ENERGY));

    handles.maxParams.Imin = 0.15*max(handles.DATA_INTENSITY);
    handles.maxParams.Imax = max(handles.DATA_INTENSITY);
    handles.maxParams.SpacingMin = 0.1;
    handles.Override = 1;        
    
    guidata(hObject,handles);
    handles = guidata(hObject);
    
    %PERFORMS GLOBAL MAX CALC
    menu_calcmaxes_Callback(hObject, eventdata, handles);
    handles = guidata(hObject);
    
    %PERFORMS FITS
    menu_calcfitparams_Callback(hObject, eventdata, handles)
    handles = guidata(hObject);    
    
    %SAVES DATA (USING USER DEFINED FILE STEM)
    refinement_data = handles.DATA;
    save([t2,filestem,num2str(ttt),'.mat'],'refinement_data');
    disp(['File ',[t2,filestem,num2str(ttt),'.mat'],' Saved Successfully']);
    tprogress = ttt/length(t1);
    guidata(hObject,handles);
end

delete(hbar);

disp('BATCH CALCULATIONS COMPLETE');
