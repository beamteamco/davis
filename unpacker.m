function varargout = unpacker(varargin)
% UNPACKER MATLAB code for unpacker.fig
%      UNPACKER, by itself, creates a new UNPACKER or raises the existing
%      singleton*.
%
%      H = UNPACKER returns the handle to a new UNPACKER or the handle to
%      the existing singleton*.
%
%      UNPACKER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNPACKER.M with the given input arguments.
%
%      UNPACKER('Property','Value',...) creates a new UNPACKER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before unpacker_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to unpacker_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help unpacker

% Last Modified by GUIDE v2.5 22-Aug-2016 21:47:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @unpacker_OpeningFcn, ...
                   'gui_OutputFcn',  @unpacker_OutputFcn, ...
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


% --- Executes just before unpacker is made visible.
function unpacker_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to unpacker (see VARARGIN)

% Choose default command line output for unpacker
handles.output = hObject;

handles.fileExist = 0;
handles.pathExist = 0;
handles.filesize = 0;

set(handles.popup_datatype,'Value',2);

handles.fnumber = str2double(get(handles.edit_fnumber,'String'));
handles.fcount = 0;
handles.snumber = str2double(get(handles.edit_splitnum,'String'));
handles.digits1 = str2double(get(handles.edit_digits1,'String'));
handles.digits2 = str2double(get(handles.edit_digits2,'String'));
handles.header = str2double(get(handles.edit_header,'String'));
% set(handles.button_open,'CData',imread('icon_folder.png'));
handles.rows = str2double(get(handles.edit_rows,'String'));
handles.cols = str2double(get(handles.edit_cols,'String'));

handles.stem1 = get(handles.edit_stem1,'String');
handles.stem2 = get(handles.edit_stem2,'String');


set(handles.button_open,'CData',imread('icon_folder.png'));
set(handles.button_save,'CData',imread('icon_folder.png'));
set(gcf,'name','Unpacker Tool')
% set(handles.text_naming,'String',[handles.stem1,num2str(0,['%0',num2str(handles.digits1),'.0f']),...
%     handles.stem2,num2str(0,['%0',num2str(handles.digits2),'.0f']),'.bin']);

handles.stem1 = get(handles.edit_stem1,'String');
handles.stem2 = get(handles.edit_stem2,'String');
handles.snumber = str2double(get(handles.edit_splitnum,'String'));
handles.digits1 = str2double(get(handles.edit_digits1,'String'));
handles.digits2 = str2double(get(handles.edit_digits2,'String'));

exten = '';
if(get(handles.checkbox_tif,'Value')==1)
    exten = '.tif';
else
    exten = '.bin';
end

if(get(handles.checkbox_split,'Value')==1)
    set(handles.text_naming,'String',[handles.stem1,num2str(0,['%0',num2str(handles.digits1),'.0f']),...
        handles.stem2,num2str(0,['%0',num2str(handles.digits2),'.0f']),exten]);
else
    set(handles.text_naming,'String',[handles.stem1,num2str(0,['%0',num2str(handles.digits1),'.0f']),exten]);
end


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes unpacker wait for user response (see UIRESUME)
% uiwait(handles.figure1);

    
% --- Outputs from this function are returned to the command line.
function varargout = unpacker_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_filepath_Callback(hObject, eventdata, handles)
% hObject    handle to edit_filepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_filepath as text
%        str2double(get(hObject,'String')) returns contents of edit_filepath as a double


% --- Executes during object creation, after setting all properties.
function edit_filepath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_filepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_open.
function button_open_Callback(hObject, eventdata, handles)
% hObject    handle to button_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[t1,t2] = uigetfile({'*.ge2','GE2 File (*.ge2)';'*.ge3','GE3 File (*.ge3)';'*.*','All Files (*.*)'},'Select File');
handles.ifilename = fullfile(t2,t1);

if(length(t1)~=1)
    set(handles.edit_filepath,'String',handles.ifilename);
    d = dir(handles.ifilename);
    handles.fileExist = 1;
    disp(d.bytes);
    handles.filesize = d.bytes;
    
    set(handles.text_fsize,'String',['Filesize: ',num2str(handles.filesize/(2^10)),' KB']);
    
    switch(get(handles.popup_datatype,'Value'))
        case(1)
            handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*1);
        case(2)
            handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*2);
        case(3)
            handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*4);
        case(4)
            handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*8);
        case(5)
            handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*1);
        case(6)
            handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*2);
        case(7)
            handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*4);
        case(8)
            handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*8);
    end
    
    set(handles.text_fcount,'String',['of ',num2str(handles.fcount)]);
    
else
    handles.fileExist = 0;
end

guidata(hObject,handles);


function edit_header_Callback(hObject, eventdata, handles)
% hObject    handle to edit_header (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_header as text
%        str2double(get(hObject,'String')) returns contents of edit_header as a double

handles.header = str2double(get(handles.edit_header,'String'));

handles.rows = str2double(get(handles.edit_rows,'String'));
handles.cols = str2double(get(handles.edit_cols,'String'));

switch(get(handles.popup_datatype,'Value'))
    case(1)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*1);
    case(2)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*2);
    case(3)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*4);
    case(4)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*8);
    case(5)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*1);
    case(6)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*2);
    case(7)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*4);
    case(8)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*8);
end

set(handles.text_fcount,'String',['of ',num2str(handles.fcount)]);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_header_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_header (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_cols_Callback(hObject, eventdata, handles)
% hObject    handle to edit_cols (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_cols as text
%        str2double(get(hObject,'String')) returns contents of edit_cols as a double

handles.header = str2double(get(handles.edit_header,'String'));

handles.rows = str2double(get(handles.edit_rows,'String'));
handles.cols = str2double(get(handles.edit_cols,'String'));

switch(get(handles.popup_datatype,'Value'))
    case(1)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*1);
    case(2)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*2);
    case(3)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*4);
    case(4)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*8);
    case(5)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*1);
    case(6)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*2);
    case(7)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*4);
    case(8)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*8);
end

set(handles.text_fcount,'String',['of ',num2str(handles.fcount)]);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_cols_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_cols (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_rows_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rows as text
%        str2double(get(hObject,'String')) returns contents of edit_rows as a double

handles.header = str2double(get(handles.edit_header,'String'));

handles.rows = str2double(get(handles.edit_rows,'String'));
handles.cols = str2double(get(handles.edit_cols,'String'));

switch(get(handles.popup_datatype,'Value'))
    case(1)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*1);
    case(2)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*2);
    case(3)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*4);
    case(4)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*8);
    case(5)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*1);
    case(6)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*2);
    case(7)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*4);
    case(8)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*8);
end

set(handles.text_fcount,'String',['of ',num2str(handles.fcount)]);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_rows_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_datatype.
function popup_datatype_Callback(hObject, eventdata, handles)
% hObject    handle to popup_datatype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_datatype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_datatype

handles.header = str2double(get(handles.edit_header,'String'));

handles.rows = str2double(get(handles.edit_rows,'String'));
handles.cols = str2double(get(handles.edit_cols,'String'));

switch(get(handles.popup_datatype,'Value'))
    case(1)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*1);
    case(2)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*2);
    case(3)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*4);
    case(4)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*8);
    case(5)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*1);
    case(6)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*2);
    case(7)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*4);
    case(8)
        handles.fcount = (handles.filesize-handles.header)/(handles.rows*handles.cols*8);
end

set(handles.text_fcount,'String',['of ',num2str(handles.fcount)]);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function popup_datatype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_datatype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_frame.
function checkbox_frame_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_frame

if(get(handles.checkbox_frame,'Value')==1)
    set(handles.edit_fnumber,'Enable','on');
    set(handles.edit_stem2,'Enable','off');
    set(handles.edit_digits2,'Enable','off');
    set(handles.edit_splitnum,'Enable','off');
    set(handles.checkbox_split,'Enable','off');
else
    set(handles.edit_fnumber,'Enable','off');
    set(handles.edit_stem2,'Enable','on');
    set(handles.edit_digits2,'Enable','on');
    set(handles.edit_splitnum,'Enable','on');
    set(handles.checkbox_split,'Enable','on');
end

guidata(hObject,handles);


function edit_fnumber_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fnumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fnumber as text
%        str2double(get(hObject,'String')) returns contents of edit_fnumber as a double
handles.fnumber = str2double(get(handles.edit_fnumber,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_fnumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fnumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_unpack.
function button_unpack_Callback(hObject, eventdata, handles)
% hObject    handle to button_unpack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.fileExist==1 && handles.pathExist==1)    
    
    switch(get(handles.popup_datatype,'Value'))
        case(1)
            mult = 1;
            format = '*uint8';
        case(2)
            mult = 2;
            format = '*uint16';
        case(3)
            mult = 4;
            format = '*uint32';
        case(4)
            mult = 8;
            format = '*uint64';
        case(5)
            mult = 1;
            format = '*int8';
        case(6)
            mult = 2;
            format = '*int16';
        case(7)
            mult = 4;
            format = '*int32';
        case(8)
            mult = 8;
            format = '*int64';
    end
    
    if(get(handles.checkbox_frame,'Value')==0)
        if(mod(handles.fcount,1)==0)
            ifstream = fopen(handles.ifilename,'r','n');            
     
            j=0;
            k=0;
            tic
            h = waitbar(0,'');
            for(i=0:handles.fcount-1)
                fseek(ifstream,handles.header+i*handles.rows*handles.cols*mult,'bof');
                data = fread(ifstream,[handles.rows handles.cols],format);
                
                
                exten = '';
                if(get(handles.checkbox_tif,'Value')==1)
                    exten = '.tif';
                else
                    exten = '.bin';
                end
                
                if(get(handles.checkbox_split,'Value')==1)
                    ofilename = fullfile(handles.ofilepath,[handles.stem1,num2str(j,['%0',num2str(handles.digits1),'.0f']),...
        handles.stem2,num2str(k,['%0',num2str(handles.digits2),'.0f']),exten]);
                else
                    ofilename = fullfile(handles.ofilepath,[handles.stem1,num2str(i,['%0',num2str(handles.digits1),'.0f']),exten]);
                end
    
                if(get(handles.checkbox_tif,'Value')==1)
                    data = double(data);
                    if(strcmp(format,'*uint16'))
                        imwrite(uint16(data),ofilename,'tif');
                    else
                        data = (data - (min(min(data))))./(max(max(data))-min(min(data)));
                        imwrite(uint16(data.*2^16),ofilename,'tif');
                    end
                else
                    ofstream = fopen(ofilename, 'w');
    %                 fwrite(ofstream, zeros(handles.rows+handles.cols,1), format(2:end));
                    fwrite(ofstream, data(:,:), format(2:end));                
                    fclose(ofstream);
                end
                
                disp(['Frame #',num2str(i+1),' completed...']);
                waitbar(i/(handles.fcount-1),h,sprintf('Frame #%i Extracted and Saved',i));                           
                k=k+1;
                if(mod(k,handles.snumber)==0)
                    j=j+1;
                    k=0;
                end
            end
            
            fclose(ifstream);
            disp(['Time Elapsed = ',num2str(toc)]);
            close(h);
            msgbox('Unpacking completed.');
        else
            msgbox('Non-integer number of frames. Please change parameters.');
        end    
    else
        if(mod(handles.fcount,1)==0)
            tic
            ifstream = fopen(handles.ifilename,'r','n');
            fseek(ifstream,handles.header+(handles.fnumber-1)*handles.rows*handles.cols*mult,'bof');
            data = fread(ifstream,[handles.rows handles.cols],format);
            
            
            exten = '';
            if(get(handles.checkbox_tif,'Value')==1)
                exten = '.tif';
            else
                exten = '.bin';
            end
                
            ofilename = fullfile(handles.ofilepath,[handles.stem1,num2str((handles.fnumber-1),['%0',num2str(handles.digits1),'.0f']),exten]);
            
            if(get(handles.checkbox_tif,'Value')==1)                
                data = double(data);
                if(strcmp(format,'*uint16'))
                    imwrite(uint16(data),ofilename,'tif');
                else
                    data = (data - (min(min(data))))./(max(max(data))-min(min(data)));
                    imwrite(uint16(data.*2^16),ofilename,'tif');
                end
            else
                ofstream = fopen(ofilename, 'w');
    %             fwrite(ofstream, zeros(handles.rows+handles.cols,1), format(2:end));
                fwrite(ofstream, data(:,:), format(2:end));            
                fclose(ofstream);
            end
            
            disp(['Frame #',num2str(handles.fnumber),' completed...']);
            
            fclose(ifstream);
            disp(['Time Elapsed = ',num2str(toc)]);
        else
            msgbox('Non-integer number of frames. Please change parameters.');
        end  
    end
    
end
guidata(hObject,handles);

% --- Executes on button press in button_close.
function button_close_Callback(hObject, eventdata, handles)
% hObject    handle to button_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close


function edit_stem1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_stem1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_stem1 as text
%        str2double(get(hObject,'String')) returns contents of edit_stem1 as a double


handles.stem1 = get(handles.edit_stem1,'String');
handles.stem2 = get(handles.edit_stem2,'String');
handles.snumber = str2double(get(handles.edit_splitnum,'String'));
handles.digits1 = str2double(get(handles.edit_digits1,'String'));
handles.digits2 = str2double(get(handles.edit_digits2,'String'));

exten = '';
if(get(handles.checkbox_tif,'Value')==1)
    exten = '.tif';
else
    exten = '.bin';
end
            
if(get(handles.checkbox_split,'Value')==1)
    set(handles.text_naming,'String',[handles.stem1,num2str(0,['%0',num2str(handles.digits1),'.0f']),...
        handles.stem2,num2str(0,['%0',num2str(handles.digits2),'.0f']),exten]);
else
    set(handles.text_naming,'String',[handles.stem1,num2str(0,['%0',num2str(handles.digits1),'.0f']),exten]);
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function edit_stem1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_stem1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_split.
function checkbox_split_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_split (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_split
handles.stem1 = get(handles.edit_stem1,'String');
handles.stem2 = get(handles.edit_stem2,'String');
handles.snumber = str2double(get(handles.edit_splitnum,'String'));
handles.digits1 = str2double(get(handles.edit_digits1,'String'));
handles.digits2 = str2double(get(handles.edit_digits2,'String'));

exten = '';
if(get(handles.checkbox_tif,'Value')==1)
    exten = '.tif';
else
    exten = '.bin';
end

if(get(handles.checkbox_split,'Value')==1)
    set(handles.text_naming,'String',[handles.stem1,num2str(0,['%0',num2str(handles.digits1),'.0f']),...
        handles.stem2,num2str(0,['%0',num2str(handles.digits2),'.0f']),exten]);
else
    set(handles.text_naming,'String',[handles.stem1,num2str(0,['%0',num2str(handles.digits1),'.0f']),exten]);
end
guidata(hObject,handles);


function edit_splitnum_Callback(hObject, eventdata, handles)
% hObject    handle to edit_splitnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_splitnum as text
%        str2double(get(hObject,'String')) returns contents of edit_splitnum as a double

handles.stem1 = get(handles.edit_stem1,'String');
handles.stem2 = get(handles.edit_stem2,'String');
handles.snumber = str2double(get(handles.edit_splitnum,'String'));
handles.digits1 = str2double(get(handles.edit_digits1,'String'));
handles.digits2 = str2double(get(handles.edit_digits2,'String'));

exten = '';
if(get(handles.checkbox_tif,'Value')==1)
    exten = '.tif';
else
    exten = '.bin';
end

if(get(handles.checkbox_split,'Value')==1)
    set(handles.text_naming,'String',[handles.stem1,num2str(0,['%0',num2str(handles.digits1),'.0f']),...
        handles.stem2,num2str(0,['%0',num2str(handles.digits2),'.0f']),exten]);
else
    set(handles.text_naming,'String',[handles.stem1,num2str(0,['%0',num2str(handles.digits1),'.0f']),exten]);
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_splitnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_splitnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_stem2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_stem2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_stem2 as text
%        str2double(get(hObject,'String')) returns contents of edit_stem2 as a double


handles.stem1 = get(handles.edit_stem1,'String');
handles.stem2 = get(handles.edit_stem2,'String');
handles.snumber = str2double(get(handles.edit_splitnum,'String'));
handles.digits1 = str2double(get(handles.edit_digits1,'String'));
handles.digits2 = str2double(get(handles.edit_digits2,'String'));

exten = '';
if(get(handles.checkbox_tif,'Value')==1)
    exten = '.tif';
else
    exten = '.bin';
end

if(get(handles.checkbox_split,'Value')==1)
    set(handles.text_naming,'String',[handles.stem1,num2str(0,['%0',num2str(handles.digits1),'.0f']),...
        handles.stem2,num2str(0,['%0',num2str(handles.digits2),'.0f']),exten]);
else
    set(handles.text_naming,'String',[handles.stem1,num2str(0,['%0',num2str(handles.digits1),'.0f']),exten]);
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function edit_stem2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_stem2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_digits1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_digits1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_digits1 as text
%        str2double(get(hObject,'String')) returns contents of edit_digits1 as a double


handles.stem1 = get(handles.edit_stem1,'String');
handles.stem2 = get(handles.edit_stem2,'String');
handles.snumber = str2double(get(handles.edit_splitnum,'String'));
handles.digits1 = str2double(get(handles.edit_digits1,'String'));
handles.digits2 = str2double(get(handles.edit_digits2,'String'));

exten = '';
if(get(handles.checkbox_tif,'Value')==1)
    exten = '.tif';
else
    exten = '.bin';
end

if(get(handles.checkbox_split,'Value')==1)
    set(handles.text_naming,'String',[handles.stem1,num2str(0,['%0',num2str(handles.digits1),'.0f']),...
        handles.stem2,num2str(0,['%0',num2str(handles.digits2),'.0f']),exten]);
else
    set(handles.text_naming,'String',[handles.stem1,num2str(0,['%0',num2str(handles.digits1),'.0f']),exten]);
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function edit_digits1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_digits1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_digits2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_digits2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_digits2 as text
%        str2double(get(hObject,'String')) returns contents of edit_digits2 as a double


handles.stem1 = get(handles.edit_stem1,'String');
handles.stem2 = get(handles.edit_stem2,'String');
handles.snumber = str2double(get(handles.edit_splitnum,'String'));
handles.digits1 = str2double(get(handles.edit_digits1,'String'));
handles.digits2 = str2double(get(handles.edit_digits2,'String'));

exten = '';
if(get(handles.checkbox_tif,'Value')==1)
    exten = '.tif';
else
    exten = '.bin';
end

if(get(handles.checkbox_split,'Value')==1)
    set(handles.text_naming,'String',[handles.stem1,num2str(0,['%0',num2str(handles.digits1),'.0f']),...
        handles.stem2,num2str(0,['%0',num2str(handles.digits2),'.0f']),exten]);
else
    set(handles.text_naming,'String',[handles.stem1,num2str(0,['%0',num2str(handles.digits1),'.0f']),exten]);
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function edit_digits2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_digits2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_outputpath_Callback(hObject, eventdata, handles)
% hObject    handle to edit_outputpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_outputpath as text
%        str2double(get(hObject,'String')) returns contents of edit_outputpath as a double
handles.ofilepath = set(handles.edit_outputpath,'String',handles.ofilepath);
handles.pathExist = 1;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_outputpath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_outputpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_save.
function button_save_Callback(hObject, eventdata, handles)
% hObject    handle to button_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.ofilepath = uigetdir('','Select Output Path');
if(length(handles.ofilepath)~=1)
    handles.pathExist = 1;
    set(handles.edit_outputpath,'String',handles.ofilepath);
else
    handles.pathExist = 0;
end
guidata(hObject,handles);


% --------------------------------------------------------------------
function menu_options_Callback(hObject, eventdata, handles)
% hObject    handle to menu_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_batch_header_remove_Callback(hObject, eventdata, handles)
% hObject    handle to menu_batch_header_remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[t1,t2] = uigetfile({'*.ge2';'*.ge3'},'Select Files','MultiSelect','on');
assignin('base','t1',t1);
if(~ischar(t2))
    return;
end

if(~iscell(t1))
    disp('Select more than one file please, otherwise use standard unpacking');
    return;
end

s1 = uigetdir('Choose Output Directory');
if(~ischar(s1))
    return;
end

title = 'Choose File Stem';
prompt = {'Choose File Stem'};
def = {'im_'};
answer = inputdlg(prompt,title,1,def);

if(isempty(answer))
    return;
end

switch(get(handles.popup_datatype,'Value'))
    case(1)
        format = '*uint8';
    case(2)
        format = '*uint16';
    case(3)
        format = '*uint32';
    case(4)
        format = '*uint64';
    case(5)
        format = '*int8';
    case(6)
        format = '*int16';
    case(7)
        format = '*int32';
    case(8)
        format = '*int64';
end   

for(i=1:size(t1,2))
    fIn = fopen(fullfile(t2,t1{i}),'r');
    fseek(fIn,handles.header,'bof');
    data = fread(fIn,[handles.rows handles.cols],format);
        
    fOut = fopen(fullfile(s1,[answer{1},num2str(i,'%04.0f'),'.nhd']),'w');
    fwrite(fOut,data(:,:),format(2:end));
    
    fclose(fIn);
    fclose(fOut);
    disp(sprintf('File %d Complete',i));
end

disp('UNPACKING COMPLETE');


% --------------------------------------------------------------------
function menu_addheader_Callback(hObject, eventdata, handles)
% hObject    handle to menu_addheader (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[t1,t2] = uigetfile('*.*','Select GE2/3 Files','Multiselect','On');

if(~ischar(t1) && ~iscell(t1))
    return
end

len = 1;
if(iscell(t1))
    len = size(t1,2);
end

im = cell(len,1);
wb = waitbar(0,'Loading XRD Data');
type = zeros(len,1);
for(i=1:len)
    fi = fopen(fullfile(t2,t1{i}));
    s = dir(fullfile(t2,t1{i}));
    
    if(s.bytes > 2048*2048*2)
        im{i} = fread(fi,[2048 2048],'*int32');
        type(i) = 32;
    else
        im{i} = fread(fi,[2048 2048],'*uint16');
        type(i) = 16;
    end
    
    fclose(fi);
    waitbar(i/len,wb,'Loading XRD Data');
end
close(wb);

[s1] = uigetdir();

if(~ischar(s1))
    return
end

wb = waitbar(0,'Saving XRD Data');
for(i=1:len)
    if(type(i)==32)
        fo = fopen(fullfile(s1,[t1{i},'.wh']),'w');
        fwrite(fo,ones(handles.header,1));
        fwrite(fo,im{i},'int32');
        fclose(fo);
    elseif(type(i)==16)
        fo = fopen(fullfile(s1,[t1{i},'.wh']),'w');
        fwrite(fo,ones(handles.header,1));
        fwrite(fo,im{i},'uint16');
        fclose(fo);
    end    
    
    waitbar(i/len,wb,'Saving XRD Data');
end
close(wb);


% --- Executes on button press in checkbox_tif.
function checkbox_tif_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_tif (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_tif

handles.stem1 = get(handles.edit_stem1,'String');
handles.stem2 = get(handles.edit_stem2,'String');
handles.snumber = str2double(get(handles.edit_splitnum,'String'));
handles.digits1 = str2double(get(handles.edit_digits1,'String'));
handles.digits2 = str2double(get(handles.edit_digits2,'String'));

exten = '';
if(get(handles.checkbox_tif,'Value')==1)
    exten = '.tif';
else
    exten = '.bin';
end

if(get(handles.checkbox_split,'Value')==1)
    set(handles.text_naming,'String',[handles.stem1,num2str(0,['%0',num2str(handles.digits1),'.0f']),...
        handles.stem2,num2str(0,['%0',num2str(handles.digits2),'.0f']),exten]);
else
    set(handles.text_naming,'String',[handles.stem1,num2str(0,['%0',num2str(handles.digits1),'.0f']),exten]);
end
guidata(hObject,handles);
