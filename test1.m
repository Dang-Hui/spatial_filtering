function varargout = test1(varargin)
% TEST1 MATLAB code for test1.fig
%      TEST1, by itself, creates a new TEST1 or raises the existing
%      singleton*.
%
%      H = TEST1 returns the handle to a new TEST1 or the handle to
%      the existing singleton*.
%
%      TEST1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST1.M with the given input arguments.
%
%      TEST1('Property','Value',...) creates a new TEST1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test1

% Last Modified by GUIDE v2.5 25-Nov-2020 08:50:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test1_OpeningFcn, ...
                   'gui_OutputFcn',  @test1_OutputFcn, ...
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


%=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x
function [X,R] = getR(menu_index, handles)

global mean_val;

points0 = str2num(get(handles.edit5,'string'));
points = str2num(get(handles.edit11,'string'));
f = 1e6*str2num(get(handles.edit3,'string'));
if f<1000e6
    set(handles.edit4,'string',0.525);
elseif f<3000e6
    set(handles.edit4,'string',0.264);
else
    set(handles.edit4,'string',0.13);
end
r = str2num(get(handles.edit4,'string'));

channels = 9;
c = 3e8;
k_rec = (1:9)';

directory2 = get(handles.edit1,'string');
if directory2(end)~='\'
    directory2 = [directory2,'\'];
end
tp1 = get(menu_index,'string');
tp2 = get(menu_index,'value');
tp = tp1{tp2};
directory = [directory2,tp];
for i=1:channels
    [I{i},Q{i}]=read_from_dat([directory,'\fft',num2str(i),'.dat']);   
end
%=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x



%==================  校正 =================================================
if points0>0
   for i=1:channels
       I1_standard{i} = I{i}(1:points0);
       Q1_standard{i} = Q{i}(1:points0);
       IQ_standard{i} = I1_standard{i} + 1i*Q1_standard{i};
   end
   for i=1:channels
       standard = wise_dot_division(IQ_standard{i},IQ_standard{1});
       mean_val(i) = mean(standard,2);
   end
else
    mean_val = ones(1,9);
end


%==================  测向 =================================================
if points0>0
    k = 2;
    for i=1:channels
        I1{i} = I{i}(k*points+1:(k+1)*points);
        Q1{i} = Q{i}(k*points+1:(k+1)*points);
        IQ{i} = I1{i}+1i*Q1{i};
    end  
    X = [];
    for i=1:channels      
        X = [X;IQ{i}/mean_val(i)];
    end
else
        k = 2;
    for i=1:channels
        I1{i} = I{i}((k-1)*points+1:k*points);
        Q1{i} = Q{i}((k-1)*points+1:k*points);
        IQ{i} = I1{i}+1i*Q1{i};
    end  
    X = [];
    for i=1:channels      
        X = [X;IQ{i}/mean_val(i)];
    end
    
end    
R = X*X';

%=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x

function handles = update_cat(handles)
tp = dir(get(handles.edit1,'string'));
%==========================判断tp是否为空===================================
if isempty(tp) %如果空读本地目录
tp = dir(pwd);
set(handles.edit1,'string',pwd)
    for i = 1:length(tp)
        tp2{i} = tp(i).name;
    end
else
    for i = 1:length(tp)
        tp2{i} = tp(i).name;
    end
end
%==========================================================================
set(handles.popupmenu1,'string',tp2)

% --- Executes just before test1 is made visible.
function test1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test1 (see VARARGIN)

% Choose default command line output for test1
clc;
% Choose default command line output for test1
handles.output = hObject;
try
    load('Setting.mat');
    set(handles.edit1,'string',Setting.edit1_setting);
    set(handles.edit3,'string',Setting.edit3_setting);
    set(handles.edit5,'string',Setting.edit5_setting);
    set(handles.edit4,'string',Setting.edit4_setting);
    set(handles.edit11,'string',Setting.edit11_setting);
    set(handles.popupmenu1,'string',Setting.popupmenu1_string_setting);
    set(handles.popupmenu1,'value',Setting.popupmenu1_value_setting);
    guidata(hObject,handles);
    
end

handles = update_cat(handles);
axes(handles.axes1); set(gca,'xtick',[]);set(gca,'ytick',[]);
axes(handles.axes2); set(gca,'xtick',[]);set(gca,'ytick',[]);
axes(handles.axes3); set(gca,'xtick',[]);set(gca,'ytick',[]);
axes(handles.axes4); set(gca,'xtick',[]);set(gca,'ytick',[]);
axes(handles.axes5); set(gca,'xtick',[]);set(gca,'ytick',[]);
axes(handles.axes6); set(gca,'xtick',[]);set(gca,'ytick',[]);
axes(handles.axes7); set(gca,'xtick',[]);set(gca,'ytick',[]);
axes(handles.axes8); set(gca,'xtick',[]);set(gca,'ytick',[]);
axes(handles.axes9); set(gca,'xtick',[]);set(gca,'ytick',[]);
axes(handles.axes10); set(gca,'xtick',[]);set(gca,'ytick',[]);
% Update handles structure
guidata(hObject, handles);
%R = getR(handles.popupmenu1,handles)
%u = getu(R);


% UIWAIT makes test1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = test1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = update_cat(handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)

global mean_val;
warning('off');%忽视警告

axes(handles.axes1);cla;
axes(handles.axes2);cla;
axes(handles.axes3);cla;
axes(handles.axes4);cla;
axes(handles.axes5);cla;
axes(handles.axes6);cla;
axes(handles.axes7);cla;
axes(handles.axes8);cla;
axes(handles.axes9);cla;
axes(handles.axes10);cla;

set(handles.edit12,'string','正在运行算法，请等待');
set(handles.edit12,'foregroundcolor','b');
pause(0.1)

[X,R] = getR(handles.popupmenu1,handles);
save('X','X');
f = 1e6*str2double(get(handles.edit3,'string'));
if f<1000e6
    set(handles.edit4,'string',0.525);
elseif f<3000e6
    set(handles.edit4,'string',0.264);
else
    set(handles.edit4,'string',0.13);
end
r = str2num(get(handles.edit4,'string'));
c = 3e8;
sample_rate = 192;%音频采样率192kHz
realsamp_rate = 256;%接收机采样率单位kHz

set(handles.edit12,'string','正在测向');
pause(0.1)

%[ direction, measure,~,~ ] = t_DML( R,f,r,c, str2num(get(handles.edit2,'string')),  1 );
%[ ~, ~, direction, measure ] = t_MUSIC( R,f,r,c, str2num(get(handles.edit2,'string')));
%[ ~, ~, direction, measure ] = t_MVDR( R,f,r,c, str2num(get(handles.edit2,'string')));
% [direction, measure ] = t_CBF( R,f,r,c, str2num(get(handles.edit2,'string')));
%[ ~,direction, measure ] = IDML_Round( R,str2num(get(handles.edit2,'string')),f,r,c);
direction=[104 258 317];
measure=[1 1 1];
axes(handles.axes1); 
plot_background;
visualize( direction, measure, 'DML' )
xlim([-1.2 1.2]);ylim([-1.2 1.2]);

set(handles.edit13,'string',['测向结果是 ',num2str(direction)]);

set(handles.edit12,'string','正在运行PSO算法');
pause(0.1)
tic
[u1,u2,u3]=mcmc_optimization(X,R,f,r,c,direction,handles,[direction(1) direction(2) direction(3)]);
% [ u1,u2,u3] = DBF_PSO_G( X,R,f,r,c,direction,handles,[direction(1) direction(2) direction(3)] );
toc
 

% =========================================================================
axes(handles.axes2);
plot_background;
visualize1( direction(1), measure(1)/max(measure), 'DML' )
xlim([-1.2 1.2]);ylim([-1.2 1.2]);
hold on;

%==========================================================================
axes(handles.axes3);
plot_background;
visualize1( direction(2), measure(2)/max(measure), 'DML' )
xlim([-1.2 1.2]);ylim([-1.2 1.2]);
hold on;

%==========================================================================
axes(handles.axes4);
plot_background;
visualize1( direction(3), measure(3)/max(measure), 'DML' )
xlim([-1.2 1.2]);ylim([-1.2 1.2]);
hold on;
 

 set(handles.edit12,'string','正在分离音频信号，请等待');
 pause(0.1)

 points0 = str2double(get(handles.edit5,'string'));
 points = str2double(get(handles.edit11,'string'));
 channels = 9;
 
 directory2 = get(handles.edit1,'string');
if directory2(end)~='\'
    directory2 = [directory2,'\'];
end
tp1 = get(handles.popupmenu1,'string');
tp2 = get(handles.popupmenu1,'value');
tp = tp1{tp2};
directory = [directory2,tp];



for i=1:channels
    [I{i},Q{i}] = read_from_dat([directory,'\fft',num2str(i),'.dat']);   
end
 
 if points0>0    
    for i = 1:channels
        I1{i} = I{i}(points+1:end);
        Q1{i} = Q{i}(points+1:end);
        IQ{i} = I1{i}+1i*Q1{i};
    end 
    clear I1 Q1 I Q;
    X = [];
    for i=1:channels      
        X = [X;IQ{i}/mean_val(i)];
    end
    clear IQ;

    be=Getaudio(X(1,:));
    
    u = perp_2( {u2, u3}, u1 );
    uN1 = (u');
    X_syn1 = uN1*X;
    af1 = Getaudio(X_syn1*10000);
    
    %clear X_syn1;
    
    u = perp_2( {u1, u3}, u2 );
    uN2 = (u');
    X_syn2 = uN2*X;
    af2 = Getaudio(X_syn2*10000);
    
    %clear X_syn2;
    
    u = perp_2( {u1, u2}, u3 );
    uN3 = (u');
    X_syn3 = uN3*X;
    af3=Getaudio(X_syn3*10000);
    
    %clear X_syn3 X;
    XX=[X_syn1(1:8192);X_syn2(1:8192);X_syn3(1:8192)];
    kurtQ = kurtosis(abs(XX),0,2);   
    residue = -sum(abs(kurtQ)); 

    be=be./max(be);
    af1=af1./max(af1);
    af2=af2./max(af2);
    af3=af3./max(af3);
    
    be = resample(be,sample_rate,realsamp_rate);
    af1 = resample(af1,sample_rate,realsamp_rate);
    af2 = resample(af2,sample_rate,realsamp_rate);
    af3 = resample(af3,sample_rate,realsamp_rate);

    audiowrite('before.wav',be,sample_rate*1000);
    audiowrite('after1.wav',af1,sample_rate*1000);
    audiowrite('after2.wav',af2,sample_rate*1000);
    audiowrite('after3.wav',af3,sample_rate*1000);
      
 else
     
    for i=1:channels
        I1{i} = I{i}(1:end);
        Q1{i} = Q{i}(1:end);
        IQ{i} = I1{i}+1i*Q1{i};
    end 
    clear I1 Q1 I Q;
    X = [];
    for i=1:channels      
        X = [X;IQ{i}/mean_val(i)];
    end
    clear IQ;

    be=Getaudio(X(1,:));
    
    u = perp_2( {u2, u3}, u1 );
    uN1 = (u');
    X_syn1 = uN1*X;
    af1=Getaudio(X_syn1*10000);
    
    clear X_syn1;
    
    u = perp_2( {u1, u3}, u2 );
    uN2 = (u');
    X_syn2 = uN2*X;
    af2=Getaudio(X_syn2*10000);
    
    clear X_syn2;
    
    u = perp_2( {u1, u2}, u3 );
    uN3 = (u');
    X_syn3 = uN3*X;
    af3=Getaudio(X_syn3*10000);
    
    clear X_syn3 X;

    be=be./max(be);
    af1=af1./max(af1);
    af2=af2./max(af2);
    af3=af3./max(af3);
    
    be = resample(be,sample_rate,realsamp_rate);
    af1 = resample(af1,sample_rate,realsamp_rate);
    af2 = resample(af2,sample_rate,realsamp_rate);
    af3 = resample(af3,sample_rate,realsamp_rate);

    audiowrite('before.wav',be,sample_rate*1000);
    audiowrite('after1.wav',af1,sample_rate*1000);
    audiowrite('after2.wav',af2,sample_rate*1000);
    audiowrite('after3.wav',af3,sample_rate*1000);
    
 end

 set(handles.edit12,'string','运算完毕！');
 
 
 
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    

Setting.edit1_setting = get(handles.edit1,'string');
Setting.edit3_setting = get(handles.edit3,'string');
Setting.edit4_setting = get(handles.edit4,'string');
Setting.edit11_setting = get(handles.edit11,'string');

save('Setting','Setting')

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


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


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear all;
[P1,fs]=audioread('after1.wav');
sound(P1,fs);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear all;
[P2,fs]=audioread('after2.wav');
sound(P2,fs);


function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


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


function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear all;
[P3,fs]=audioread('after3.wav');
sound(P3,fs);

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear all;
[Pb,fs]=audioread('before.wav');
sound(Pb,fs);



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


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


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear sound
