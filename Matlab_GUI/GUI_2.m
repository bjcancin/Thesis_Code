function varargout = GUI_2(varargin)
% GUI_2 MATLAB code for GUI_2.fig
%      GUI_2, by itself, creates a new GUI_2 or raises the existing
%      singleton*.
%
%      H = GUI_2 returns the handle to a new GUI_2 or the handle to
%      the existing singleton*.
%
%      GUI_2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_2.M with the given input arguments.
%
%      GUI_2('Property','Value',...) creates a new GUI_2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_2

% Last Modified by GUIDE v2.5 15-Oct-2015 16:03:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_2_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_2_OutputFcn, ...
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


% --- Executes just before GUI_2 is made visible.
function GUI_2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_2 (see VARARGIN)

% Choose default command line output for GUI_2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in save_data.
function save_data_Callback(hObject, eventdata, handles)
    [file,path] = uiputfile('*.mat','Guardar Parámetros');
    
    data.in_i = handles.in_i;
    data.out_i = handles.out_i;
    data.in_r = handles.in_r;
    data.out_r = handles.out_r;
    
    save([path file], 'data');


% --- Executes on button press in load_data.
function load_data_Callback(hObject, eventdata, handles)
    [FileName,PathName] = uigetfile('*.mat','Selecciona el archivo...');
    input = load([PathName FileName]);
    
    % Seteamos los parámetros
    
    % Imagen
    set(handles.up_i, 'String', strrep(mat2str(input.data.out_i.up,2),' ',' '));
    set(handles.down_i, 'String', strrep(mat2str(input.data.out_i.down,2),' ',' '));
    
    set(handles.fclock_i, 'String', num2str(input.data.in_i.f_clock));
    set(handles.fstep_i, 'String', num2str(input.data.in_i.f_step));
    set(handles.duty_i, 'String', num2str(input.data.in_i.Duty));
    set(handles.avp_i, 'String', num2str(input.data.in_i.A_v_p));
    set(handles.avm_i, 'String', num2str(input.data.in_i.A_v_m));
    
    set(handles.ai_i, 'String', num2str(input.data.in_i.A_i));
    set(handles.irms_i, 'String', num2str(input.data.in_i.i_rms));
    set(handles.idle_i, 'String', num2str(input.data.in_i.idle));
    set(handles.c_i, 'String', num2str(input.data.in_i.C));
    
    set(handles.iop1, 'Value', input.data.in_i.iop1);
    set(handles.iop2, 'Value', input.data.in_i.iop2);
    set(handles.iop3, 'Value', input.data.in_i.iop3);
    set(handles.iop4, 'Value', input.data.in_i.iop4);
    set(handles.rst, 'Value', input.data.in_i.rst);
    
    
    % Registro
    set(handles.up_r, 'String', strrep(mat2str(input.data.out_r.up,2),' ',' '));
    set(handles.down_r, 'String', strrep(mat2str(input.data.out_r.down,2),' ',' '));
    
    set(handles.fclock_r, 'String', num2str(input.data.in_r.f_clock));
    set(handles.fstep_r, 'String', num2str(input.data.in_r.f_step));
    set(handles.duty_r, 'String', num2str(input.data.in_r.Duty));
    set(handles.avp_r, 'String', num2str(input.data.in_r.A_v_p));
    set(handles.avm_r, 'String', num2str(input.data.in_r.A_v_m));
    
    set(handles.ai_r, 'String', num2str(input.data.in_r.A_i));
    set(handles.irms_r, 'String', num2str(input.data.in_r.i_rms));
    set(handles.idle_r, 'String', num2str(input.data.in_r.idle));
    set(handles.c_r, 'String', num2str(input.data.in_r.C));
    
    set(handles.rop1, 'Value', input.data.in_r.rop1);
    set(handles.rop2, 'Value', input.data.in_r.rop2);
    set(handles.rop3, 'Value', input.data.in_r.rop3);
    set(handles.rop4, 'Value', input.data.in_r.rop4);


% --- Executes on button press in program_fpga.
function program_fpga_Callback(hObject, eventdata, handles)
    
    in.iop1 = handles.in_i.iop1;
    in.iop2 = handles.in_i.iop2;
    in.iop3 = handles.in_i.iop3;
    in.iop4 = handles.in_i.iop4;
    in.rop1 = handles.in_r.rop1;
    in.rop2 = handles.in_r.rop2;
    in.rop3 = handles.in_r.rop3;
    in.rop4 = handles.in_r.rop4;
    
    in.rst = handles.in_i.rst;
    
    in.up_i = [handles.out_i.up_b zeros(1, 10 - length(handles.out_i.up_b))];
    in.down_i = [handles.out_i.down_b zeros(1, 10 - length(handles.out_i.down_b))];
    
    in.up_r = [handles.out_r.up_b zeros(1, 10 - length(handles.out_r.up_b))];
    in.down_r = [handles.out_r.down_b zeros(1, 10 - length(handles.out_r.down_b))];
    
    in.nup_i = length(handles.out_i.up_b);
    in.ndown_i = length(handles.out_i.down_b);
    
    in.nup_r = length(handles.out_r.up_b);
    in.ndown_r = length(handles.out_r.down_b);
    
    in.idle_i = handles.out_i.idle_b;
    in.idle_r = handles.out_r.idle_b;
    
    in.fstep_i = handles.in_i.f_step;
    in.fstep_r = handles.in_r.f_step;
    
    aux = get(handles.serial_ports, 'String');
    aux2 = get(handles.serial_ports, 'Value');
    in.serial_port = aux{aux2};
    
    set(handles.status_fpga, 'String', 'Programando...');
    
    Serial_2(in);
    
    set(handles.status_fpga, 'String', 'Finalizado');


% --- Executes on button press in search_serial.
function search_serial_Callback(hObject, eventdata, handles)
    serialPorts = instrhwinfo('serial');
        
    set(handles.serial_ports, 'String', ...
    [{'Selecciona'} ; serialPorts.SerialPorts ]);
    
    




% --- Executes on selection change in serial_ports.
function serial_ports_Callback(hObject, eventdata, handles)
% hObject    handle to serial_ports (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns serial_ports contents as cell array
%        contents{get(hObject,'Value')} returns selected item from serial_ports


% --- Executes during object creation, after setting all properties.
function serial_ports_CreateFcn(hObject, eventdata, handles)
% hObject    handle to serial_ports (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function up_i_Callback(hObject, eventdata, handles)
% hObject    handle to up_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of up_i as text
%        str2double(get(hObject,'String')) returns contents of up_i as a double


% --- Executes during object creation, after setting all properties.
function up_i_CreateFcn(hObject, eventdata, handles)
% hObject    handle to up_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function down_i_Callback(hObject, eventdata, handles)
% hObject    handle to down_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of down_i as text
%        str2double(get(hObject,'String')) returns contents of down_i as a double


% --- Executes during object creation, after setting all properties.
function down_i_CreateFcn(hObject, eventdata, handles)
% hObject    handle to down_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fclock_i_Callback(hObject, eventdata, handles)
% hObject    handle to fclock_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fclock_i as text
%        str2double(get(hObject,'String')) returns contents of fclock_i as a double


% --- Executes during object creation, after setting all properties.
function fclock_i_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fclock_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fstep_i_Callback(hObject, eventdata, handles)
% hObject    handle to fstep_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fstep_i as text
%        str2double(get(hObject,'String')) returns contents of fstep_i as a double


% --- Executes during object creation, after setting all properties.
function fstep_i_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fstep_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function duty_i_Callback(hObject, eventdata, handles)
% hObject    handle to duty_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of duty_i as text
%        str2double(get(hObject,'String')) returns contents of duty_i as a double


% --- Executes during object creation, after setting all properties.
function duty_i_CreateFcn(hObject, eventdata, handles)
% hObject    handle to duty_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function avp_i_Callback(hObject, eventdata, handles)
% hObject    handle to avp_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of avp_i as text
%        str2double(get(hObject,'String')) returns contents of avp_i as a double


% --- Executes during object creation, after setting all properties.
function avp_i_CreateFcn(hObject, eventdata, handles)
% hObject    handle to avp_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function avm_i_Callback(hObject, eventdata, handles)
% hObject    handle to avm_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of avm_i as text
%        str2double(get(hObject,'String')) returns contents of avm_i as a double


% --- Executes during object creation, after setting all properties.
function avm_i_CreateFcn(hObject, eventdata, handles)
% hObject    handle to avm_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ai_i_Callback(hObject, eventdata, handles)
% hObject    handle to ai_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ai_i as text
%        str2double(get(hObject,'String')) returns contents of ai_i as a double


% --- Executes during object creation, after setting all properties.
function ai_i_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ai_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function irms_i_Callback(hObject, eventdata, handles)
% hObject    handle to irms_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of irms_i as text
%        str2double(get(hObject,'String')) returns contents of irms_i as a double


% --- Executes during object creation, after setting all properties.
function irms_i_CreateFcn(hObject, eventdata, handles)
% hObject    handle to irms_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function idle_i_Callback(hObject, eventdata, handles)
% hObject    handle to idle_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of idle_i as text
%        str2double(get(hObject,'String')) returns contents of idle_i as a double


% --- Executes during object creation, after setting all properties.
function idle_i_CreateFcn(hObject, eventdata, handles)
% hObject    handle to idle_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c_i_Callback(hObject, eventdata, handles)
% hObject    handle to c_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c_i as text
%        str2double(get(hObject,'String')) returns contents of c_i as a double


% --- Executes during object creation, after setting all properties.
function c_i_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in iop1.
function iop1_Callback(hObject, eventdata, handles)
% hObject    handle to iop1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of iop1


% --- Executes on button press in iop2.
function iop2_Callback(hObject, eventdata, handles)
% hObject    handle to iop2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of iop2


% --- Executes on button press in iop3.
function iop3_Callback(hObject, eventdata, handles)
% hObject    handle to iop3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of iop3


% --- Executes on button press in iop4.
function iop4_Callback(hObject, eventdata, handles)
% hObject    handle to iop4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of iop4


% --- Executes on button press in load_i.
function load_i_Callback(hObject, eventdata, handles)

    in.up = eval(get(handles.up_i,'String'));
    in.down = eval(get(handles.down_i,'String'));
    in.A_v_m = eval(get(handles.avm_i,'String'));
    in.A_v_p = eval(get(handles.avp_i,'String'));
    in.Duty = eval(get(handles.duty_i,'String'));
	in.f_clock = eval(get(handles.fclock_i,'String'));
    in.f_step = eval(get(handles.fstep_i,'String'));
    in.C = eval(get(handles.c_i,'String'));
    in.A_i = eval(get(handles.ai_i,'String'));
    in.i_rms = eval(get(handles.irms_i,'String'));
    in.idle = eval(get(handles.idle_i,'String'));
    in.iop1 = get(handles.iop1, 'Value');
    in.iop2 = get(handles.iop2, 'Value');
    in.iop3 = get(handles.iop3, 'Value');
    in.iop4 = get(handles.iop4, 'Value');
    in.rst = get(handles.iop4, 'Value');
    
    out = Plot_Clock3(in);
    
    axes(handles.plot_i);
    [ax,p1,p2] = plotyy(out.t_plot,out.v_plot,out.t_plot,out.i_plot,'plot','plot');
    
    title('Gráfico de Imagen');
    grid;
    xlabel(ax(1),'Tiempo [s]');
    ylabel(ax(1),'Voltaje [V]');
    ylabel(ax(2),'Corriente [A]');
    A = (in.A_v_p - in.A_v_m)*0.1;
    set(ax(1),'YLim',[in.A_v_m-A in.A_v_p+A]);
    
    % Cargamos los nuevos datos
    set(handles.irmso_i,'String',num2str(out.i_rms, '%1.2f'));
    if(out.i_rms < in.i_rms)
       set(handles.irmso_i,'BackgroundColor','green');
    else
        set(handles.irmso_i,'BackgroundColor','red');
    end
    
    set(handles.up_i, 'String',strrep(mat2str(out.up,2),' ',' '));
    set(handles.up_i,'BackgroundColor','green');
    
    set(handles.down_i, 'String', strrep(mat2str(out.down,2),' ',' '));
    set(handles.down_i,'BackgroundColor','green');
    
    handles.in_i = in;
    handles.out_i = out;
    guidata(hObject, handles);





function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7


% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox8


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function up_r_Callback(hObject, eventdata, handles)
% hObject    handle to up_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of up_r as text
%        str2double(get(hObject,'String')) returns contents of up_r as a double


% --- Executes during object creation, after setting all properties.
function up_r_CreateFcn(hObject, eventdata, handles)
% hObject    handle to up_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function down_r_Callback(hObject, eventdata, handles)
% hObject    handle to down_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of down_r as text
%        str2double(get(hObject,'String')) returns contents of down_r as a double


% --- Executes during object creation, after setting all properties.
function down_r_CreateFcn(hObject, eventdata, handles)
% hObject    handle to down_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fclock_r_Callback(hObject, eventdata, handles)
% hObject    handle to fclock_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fclock_r as text
%        str2double(get(hObject,'String')) returns contents of fclock_r as a double


% --- Executes during object creation, after setting all properties.
function fclock_r_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fclock_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fstep_r_Callback(hObject, eventdata, handles)
% hObject    handle to fstep_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fstep_r as text
%        str2double(get(hObject,'String')) returns contents of fstep_r as a double


% --- Executes during object creation, after setting all properties.
function fstep_r_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fstep_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function duty_r_Callback(hObject, eventdata, handles)
% hObject    handle to duty_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of duty_r as text
%        str2double(get(hObject,'String')) returns contents of duty_r as a double


% --- Executes during object creation, after setting all properties.
function duty_r_CreateFcn(hObject, eventdata, handles)
% hObject    handle to duty_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function avp_r_Callback(hObject, eventdata, handles)
% hObject    handle to avp_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of avp_r as text
%        str2double(get(hObject,'String')) returns contents of avp_r as a double


% --- Executes during object creation, after setting all properties.
function avp_r_CreateFcn(hObject, eventdata, handles)
% hObject    handle to avp_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function avm_r_Callback(hObject, eventdata, handles)
% hObject    handle to avm_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of avm_r as text
%        str2double(get(hObject,'String')) returns contents of avm_r as a double


% --- Executes during object creation, after setting all properties.
function avm_r_CreateFcn(hObject, eventdata, handles)
% hObject    handle to avm_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ai_r_Callback(hObject, eventdata, handles)
% hObject    handle to ai_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ai_r as text
%        str2double(get(hObject,'String')) returns contents of ai_r as a double


% --- Executes during object creation, after setting all properties.
function ai_r_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ai_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function irms_r_Callback(hObject, eventdata, handles)
% hObject    handle to irms_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of irms_r as text
%        str2double(get(hObject,'String')) returns contents of irms_r as a double


% --- Executes during object creation, after setting all properties.
function irms_r_CreateFcn(hObject, eventdata, handles)
% hObject    handle to irms_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function idle_r_Callback(hObject, eventdata, handles)
% hObject    handle to idle_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of idle_r as text
%        str2double(get(hObject,'String')) returns contents of idle_r as a double


% --- Executes during object creation, after setting all properties.
function idle_r_CreateFcn(hObject, eventdata, handles)
% hObject    handle to idle_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c_r_Callback(hObject, eventdata, handles)
% hObject    handle to c_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c_r as text
%        str2double(get(hObject,'String')) returns contents of c_r as a double


% --- Executes during object creation, after setting all properties.
function c_r_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rop1.
function rop1_Callback(hObject, eventdata, handles)
% hObject    handle to rop1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rop1


% --- Executes on button press in rop2.
function rop2_Callback(hObject, eventdata, handles)
% hObject    handle to rop2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rop2


% --- Executes on button press in rop3.
function rop3_Callback(hObject, eventdata, handles)
% hObject    handle to rop3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rop3


% --- Executes on button press in rop4.
function rop4_Callback(hObject, eventdata, handles)
% hObject    handle to rop4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rop4


% --- Executes on button press in load_r.
function load_r_Callback(hObject, eventdata, handles)
    in.up = eval(get(handles.up_r,'String'));
    in.down = eval(get(handles.down_r,'String'));
    in.A_v_m = eval(get(handles.avm_r,'String'));
    in.A_v_p = eval(get(handles.avp_r,'String'));
    in.Duty = eval(get(handles.duty_r,'String'));
	in.f_clock = eval(get(handles.fclock_r,'String'));
    in.f_step = eval(get(handles.fstep_r,'String'));
    in.C = eval(get(handles.c_r,'String'));
    in.A_i = eval(get(handles.ai_r,'String'));
    in.i_rms = eval(get(handles.irms_r,'String'));
    in.idle = eval(get(handles.idle_r,'String'));
    in.rop1 = get(handles.rop1, 'Value');
    in.rop2 = get(handles.rop2, 'Value');
    in.rop3 = get(handles.rop3, 'Value');
    in.rop4 = get(handles.rop4, 'Value');
    
    
    out = Plot_Clock3(in);
    
    axes(handles.plot_r);
    [ax,p1,p2] = plotyy(out.t_plot,out.v_plot,out.t_plot,out.i_plot,'plot','plot');
    
    title('Gráfico de Registro');
    grid;
    xlabel(ax(1),'Tiempo [s]');
    ylabel(ax(1),'Voltaje [V]');
    ylabel(ax(2),'Corriente [A]');
    A = (in.A_v_p - in.A_v_m)*0.1;
    set(ax(1),'YLim',[in.A_v_m-A in.A_v_p+A]);
    
    % Cargamos los nuevos datos
    set(handles.irmso_r,'String',num2str(out.i_rms, '%1.2f'));
    if(out.i_rms < in.i_rms)
       set(handles.irmso_r,'BackgroundColor','green');
    else
        set(handles.irmso_r,'BackgroundColor','red');
    end
    
    set(handles.up_r, 'String',strrep(mat2str(out.up,2),' ',' '));
    set(handles.up_r,'BackgroundColor','green');
    
    set(handles.down_r, 'String', strrep(mat2str(out.down,2),' ',' '));
    set(handles.down_r,'BackgroundColor','green');
    
    handles.out_r = out;
    handles.in_r = in;
    handles.prueba = 1;
    
    % Update handles structure
    guidata(hObject, handles);
    
    

    


% --- Executes on key press with focus on iop1 and none of its controls.
function iop1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to iop1 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in rst.
function rst_Callback(hObject, eventdata, handles)
% hObject    handle to rst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rst
