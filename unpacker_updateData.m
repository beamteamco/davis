function [hObject,handles] = unpacker_updateData(f_hObject,f_handles)

handles.fnumber = str2double(get(f_handles.edit_fnumber,'String'));

handles.snumber = str2double(get(f_handles.edit_splitnum,'String'));
handles.digits1 = str2double(get(f_handles.edit_digits1,'String'));
handles.digist2 = str2double(get(f_handles.edit_digits2,'String'));
handles.header = str2double(get(f_handles.edit_header,'String'));

handles.rows = str2double(get(f_handles.edit_rows,'String'));
handles.cols = str2double(get(f_handles.edit_cols,'String'));

handles.stem1 = get(f_handles.edit_stem1,'String');
handles.stem2 = get(f_handles.edit_stem2,'String');

set(f_handles.text_fsize,'String',['Filesize: ',num2str(f_handles.filesize/(2^10)),' KB']);
    
switch(get(f_handles.popup_datatype,'Value'))
    case(1)
        handles.fcount = (f_handles.filesize-f_handles.header)/(f_handles.rows*f_handles.cols*1);
    case(2)
        handles.fcount = (f_handles.filesize-f_handles.header)/(f_handles.rows*f_handles.cols*2);
    case(3)
        handles.fcount = (f_handles.filesize-f_handles.header)/(f_handles.rows*f_handles.cols*4);
    case(4)
        handles.fcount = (f_handles.filesize-f_handles.header)/(f_handles.rows*f_handles.cols*8);
    case(5)
        handles.fcount = (f_handles.filesize-f_handles.header)/(f_handles.rows*f_handles.cols*1);
    case(6)
        handles.fcount = (f_handles.filesize-f_handles.header)/(f_handles.rows*f_handles.cols*2);
    case(7)
        handles.fcount = (f_handles.filesize-f_handles.header)/(f_handles.rows*f_handles.cols*4);
    case(8)
        handles.fcount = (f_handles.filesize-f_handles.header)/(f_handles.rows*f_handles.cols*8);
end

set(f_handles.text_fcount,'String',['of ',num2str(handles.fcount)]);