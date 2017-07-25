function varargout = postpro2(varargin)
% POSTPRO2 MATLAB code for postpro2.fig
%      POSTPRO2, by itself, creates a new POSTPRO2 or raises the existing
%      singleton*.
%
%      H = POSTPRO2 returns the handle to a new POSTPRO2 or the handle to
%      the existing singleton*.
%
%      POSTPRO2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POSTPRO2.M with the given input arguments.
%
%      POSTPRO2('Property','Value',...) creates a new POSTPRO2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before postpro2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to postpro2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help postpro2

% Last Modified by GUIDE v2.5 10-Jul-2017 17:31:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @postpro2_OpeningFcn, ...
                   'gui_OutputFcn',  @postpro2_OutputFcn, ...
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


% --- Executes just before postpro2 is made visible.
function postpro2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to postpro2 (see VARARGIN)

% Choose default command line output for postpro2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes postpro2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = postpro2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function astra_files_lst_CreateFcn(hObject, eventdata, handles)
% hObject    handle to astra_files_lst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function visual_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

astra_structure = updatadata(hObject, eventdata, handles);
condition = get(handles.plot_condition,'String');
rawdata = applycondition(astra_structure,condition);
[x,y,z,px,py,pz,time,xp,yp,Ek,charge] = data2local(rawdata);

if get(handles.emit_cal_chk,'Value')
% data = [x[cm],xp[mrad],y[cm],y[mrad],time[ns],Ek[MeV]];
emitdata =  [x/10,xp,y/10,yp,time*1E-3,Ek];
% number slice
numberslice = str2double(get(handles.number_slice,'String'));
% emit cal
sliced_data = slice_dist(emitdata,min(Ek),max(Ek),numberslice);
projected_data = slice_dist(emitdata,min(Ek),max(Ek),1);
% calculate emit, normalized phasespace and phase ellipse
slice_emit = get_emit(sliced_data);
projected_emit = get_emit(projected_data);
% calculate phase space and phase ellipse
phasespace = normalized_phasespace(sliced_data,slice_emit);
phaseellipse.x = ellipse_phasespace(slice_emit,'x',500);
phaseellipse.y = ellipse_phasespace(slice_emit,'y',500);
% update handles
handles.projected_emit = projected_emit;
handles.slice_emit = slice_emit;
handles.phasespace = phasespace;
handles.phaseellipse = phaseellipse;
end


handles.data = rawdata;
handles.astra_structure = astra_structure;
guidata(hObject, handles);
plotcommand = get(handles.plot_command,'String');
visualize(plotcommand,handles)


function visualize(plotcommand,handles)
data = handles.data;
if get(handles.emit_cal_chk,'Value')
phasespace = handles.phasespace;
phaseellipse = handles.phaseellipse;
end
figure;
[x,y,z,px,py,pz,time,xp,yp,Ek,charge] = data2local(data);
% plot
eval(plotcommand);
% limit
if ~isempty(get(handles.lim_xaxis,'String'))
xlim(str2num(get(handles.lim_xaxis,'String')));
end
if ~isempty(get(handles.lim_yaxis,'String'))
ylim(str2num(get(handles.lim_yaxis,'String')));
end
% label
xlabel(get(handles.Label_x,'String'))
ylabel(get(handles.Label_y,'String'))
% frame
if get(handles.box_chk,'Value')
    box on;
else
    box off;
end
if get(handles.grid_chk,'Value')
    grid on;
end
if get(handles.grid_minor_chk,'Value')
    grid minor;
else
    grid off;
end
if get(handles.axisequal_chk,'Value')
    axis equal;
else
    axis auto;
end
    
function output = applycondition(astra,condition)
% x,y,z in mm
% px,py,pz in eV/c
% time in ps
% charge in pC
% xp,yp in mrad
% Ek in MeV

x = astra.data(:,1)*1E3;
y = astra.data(:,2)*1E3;
z = astra.data(:,3)*1E3;
px = astra.data(:,4);
py = astra.data(:,5);
pz = astra.data(:,6);
time = astra.data(:,7)*1E3;
charge = astra.data(:,8)*1E3;

% calculate Ek in MeV
ptotal = sqrt(px.^2+py.^2+pz.^2);
Ek = p2E(ptotal);
xp = atan(px./ptotal)*1000; % unit in mrad
yp = atan(py./ptotal)*1000;

if isempty(condition)
else
cond = eval(condition);
x = x(cond);
y = y(cond);
z = z(cond);
px = px(cond);
py = py(cond);
pz = pz(cond);
time = time(cond);
charge = charge(cond);
Ek = Ek(cond);
xp = xp(cond);
yp = yp(cond);
end
output.x = x;
output.y = y;
output.z = z;

output.px = px;
output.py = py;
output.pz = pz;

output.time = time;
output.charge = charge;
output.Ek = Ek;
output.xp = xp;
output.yp = yp;

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function plot_command_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plot_command (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function plot_condition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plot_condition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function lim_xaxis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lim_xaxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function lim_yaxis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lim_yaxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function load_folder_Callback(hObject, eventdata, handles)
% hObject    handle to load_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% selection multi files
[astra_files,astra_path] = uigetfile('*.????.???',pwd,'Load Astra working folder','MultiSelect','on');

% load multi path to handles
if iscell(astra_files)
for i=1:length(astra_files)
    handles.astra_pathfile{i} = fullfile(astra_path,astra_files{i});
    guidata(hObject,handles);
end
else
    handles.astra_pathfile{1} = fullfile(astra_path,astra_files);
    guidata(hObject,handles);
end
% display astra files to astra_files_lst
handles.astra_files_lst.String = astra_files;
% current path
handles.current_astra_path = 1;
set(handles.astra_files_lst,'Value',handles.current_astra_path)
% display path
set(handles.showFilePath_txt,'String',astra_path)

function output = read_astra_file(astra_filepath)
output = savedist2mat('Astra',astra_filepath);

function about_Callback(hObject, eventdata, handles)

msgbox({'Developer:' 'Chaipattana Saisaard'});

% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Label_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Label_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Label_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Label_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function astra_structure = updatadata(hObject, eventdata, handles)
astra_structure = read_astra_file(handles.astra_pathfile{get(handles.astra_files_lst,'Value')});

function [x,y,z,px,py,pz,time,xp,yp,Ek,charge] = data2local(data)
x = data.x;
y = data.y;
z = data.z;
px = data.px;
py = data.py;
pz = data.pz;
time = data.time;
xp = data.xp;
yp = data.yp;
Ek = data.Ek;
charge = data.charge;

function ShowPercentile_Callback(hObject, eventdata, handles)
% update data
astra_structure = updatadata(hObject, eventdata, handles);
% condition = get(handles.plot_condition,'String');
data = applycondition(astra_structure,'');
% assign to common variables
[x,y,z,px,py,pz,time,xp,yp,Ek,charge] = data2local(data);
% read min and max percentile
minper = str2num(get(handles.minPercentile,'String'));
maxper = str2num(get(handles.maxPercentile,'String'));
% dummy
dummy1 = get(handles.var1,'String');
dummy2 = get(handles.var2,'String');
j =1;
for i =minper:1:maxper
    % condition
    Ekmin(j) = prctile(Ek,i);
    cond = find(Ek>Ekmin(j));
    x = x(cond);
    y = y(cond);
    z = z(cond);
    px = px(cond);
    py = py(cond);
    pz = pz(cond);
    time = time(cond);
    xp = xp(cond);
    yp = yp(cond);
    Ek = Ek(cond);
    charge = charge(cond);
    
    var1(j) = eval(dummy1);
if ~isempty(get(handles.var2,'String'))    
    var2(j) = eval(dummy2);
end
    j = j+1;
end
figure;
plot([minper:1:maxper],var1,'-*');
if ~isempty(get(handles.var2,'String'))
    yyaxis right
    plot([minper:1:maxper],var2,'-o');
end

function beam_stat_eval_Callback(hObject, eventdata, handles)

    astra_structure = updatadata(hObject, eventdata, handles);
    condition = get(handles.plot_condition,'String');
    data = applycondition(astra_structure,condition);
    [x,y,z,px,py,pz,time,xp,yp,Ek,charge] = data2local(data);
    if get(handles.emit_cal_chk,'Value')
        emit.proj = handles.projected_emit;
        emit.slic = handles.slice_emit;
    end
    command = get(handles.beam_stat,'String');
    % evaluate command

    value = eval(command);
    if iscell(value)
        value = cell2mat(value);
    end
    % return value to display
    set(handles.show_beam_stat,'String',num2str(value));
    
function emittance_eval(hObject, eventdata, handles)

astra_structure = updatadata(hObject, eventdata, handles);
condition = get(handles.plot_condition,'String');
rawdata = applycondition(astra_structure,condition);
[x,y,z,px,py,pz,time,xp,yp,Ek,charge] = data2local(rawdata);

% data = [x[cm],xp[mrad],y[cm],y[mrad],time[ns],Ek[MeV]];
data =  [x/10,xp,y/10,yp,time*1E-3,Ek];
% number slice
numberslice = str2double(get(handles.number_slice,'String'));

sliced_data = slice_dist(data,min(Ek),max(Ek),numberslice);
projected_data = slice_dist(data,min(Ek),max(Ek),1);

% calculate emit, normalized phasespace and phase ellipse
slice_emit = get_emit(sliced_data);
projected_emit = get_emit(projected_data);
% calculate phase space and phase ellipse
phasespace = normalized_phasespace(sliced_data,slice_emit);

phaseellipse.x = ellipse_phasespace(slice_emit,'x',500);
phaseellipse.y = ellipse_phasespace(slice_emit,'y',500);
%cscatter(phase_ellipse.x.geo)
% cscatter(phasespace.x.geo)
% cscatter(phaseellipse.y.norm)
% handles.phasespace = phasespace;
% handles.phasespace = phasespace;
handles.projected_emit = projected_emit;
handles.slice_emit = slice_emit;
handles.phasespace = phasespace;
handles.phaseellipse = phaseellipse;
guidata(hObject, handles);



