function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 15-Dec-2016 00:04:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GUI_OpeningFcn, ...
    'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(handles.PSOiteration,'string','50');

psoIterations=50;
assignin('base','psoIterations',psoIterations)

vecval=1;
assignin('base','vecval',vecval)

ofval=1;
assignin('base','ofval',ofval)

psoSwarmSize=20;
set(handles.PSOSwarmsize,'string','20');
assignin('base','psoSwarmSize',psoSwarmSize)


set(handles.ac1,'string','1');
set(handles.PSOacSlider,'string','1');
ac1=1;
assignin('base','ac1',ac1)

iw1 = 1;
set(handles.iw1,'string','1');
set(handles.PSOiwSlider,'string','1');
assignin('base','iw1',iw1)

epSwarmSize = 20;
set(handles.epSwarmsize,'string','20');
assignin('base','epSwarmSize',epSwarmSize)

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in startSimulation.
function startSimulation_Callback(hObject, eventdata, handles)
% hObject    handle to startSimulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes3,'reset');
cla(handles.axes1,'reset');
cla(handles.axes4,'reset');
cla(handles.axes5,'reset');
cla(handles.axes2,'reset');

pause(0.1);
run main.m


function epIteration_Callback(hObject, eventdata, handles)
% hObject    handle to epIteration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epIteration as text
%        str2double(get(hObject,'String')) returns contents of epIteration as a double
epIteration = str2double(get(hObject,'String'));
assignin('base','epIteration',epIteration)



function epSwarmsize_Callback(hObject, eventdata, handles)
% hObject    handle to epSwarmsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epSwarmsize as text
%        str2double(get(hObject,'String')) returns contents of epSwarmsize as a double
epSwarmSize =str2double(get(hObject,'String'))
assignin('base','epSwarmSize',epSwarmSize)

% --- Executes during object creation, after setting all properties.
function epSwarmsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epSwarmsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on slider movement.
function PSOiwSlider_Callback(hObject, eventdata, handles)
% hObject    handle to PSOiwSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
iw1 = get(hObject,'Value');
set(handles.iw1,'String',num2str(iw1));
assignin('base','iw1',iw1)

% --- Executes during object creation, after setting all properties.
function PSOiwSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PSOiwSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function PSOSwarmsize_Callback(hObject, eventdata, handles)
% hObject    handle to PSOSwarmsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PSOSwarmsize as text
%        str2double(get(hObject,'String')) returns contents of PSOSwarmsize as a double
psoSwarmSize = str2double(get(hObject,'String'));
assignin('base','psoSwarmSize',psoSwarmSize)

% --- Executes during object creation, after setting all properties.
function PSOSwarmsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PSOSwarmsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PSOiteration_Callback(hObject, eventdata, handles)
% hObject    handle to PSOiteration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PSOiteration as text
%        str2double(get(hObject,'String')) returns contents of PSOiteration as a double
psoIterations = str2double(get(hObject,'String'));
assignin('base','psoIterations',psoIterations)


% --- Executes during object creation, after setting all properties.
function PSOiteration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PSOiteration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function PSOacSlider_Callback(hObject, eventdata, handles)
% hObject    handle to PSOacSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

ac1 = get(hObject,'Value');
set(handles.ac1,'String',num2str(ac1));
assignin('base','ac1',ac1)

% --- Executes during object creation, after setting all properties.
function PSOacSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PSOacSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pauseSimulation.
function pauseSimulation_Callback(hObject, eventdata, handles)
% hObject    handle to pauseSimulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(0,'FLAG', true)

% --- Executes on button press in continueSimulation.
function continueSimulation_Callback(hObject, eventdata, handles)
% hObject    handle to continueSimulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(0,'FLAG', false)


% --- Executes on selection change in vectorfields.
function vectorfields_Callback(hObject, eventdata, handles)
% hObject    handle to vectorfields (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns vectorfields contents as cell array
%        contents{get(hObject,'Value')} returns selected item from vectorfields
vecval = get(hObject,'Value');
assignin('base','vecval',vecval)
% --- Executes during object creation, after setting all properties.
function vectorfields_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vectorfields (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in objectivefunctions.
function objectivefunctions_Callback(hObject, eventdata, handles)
% hObject    handle to objectivefunctions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns objectivefunctions contents as cell array
%        contents{get(hObject,'Value')} returns selected item from objectivefunctions
ofval = get(hObject,'Value');
assignin('base','ofval',ofval);

% --- Executes during object creation, after setting all properties.
function objectivefunctions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to objectivefunctions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in vfield.
function vfield_Callback(hObject, eventdata, handles)
% hObject    handle to vfield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of vfield


% --- Executes on button press in information.
function information_Callback(hObject, eventdata, handles)
% hObject    handle to information (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of information


% --- Executes on button press in contour.
function contour_Callback(hObject, eventdata, handles)
% hObject    handle to contour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of contour



function vMax_Callback(hObject, eventdata, handles)
% hObject    handle to vMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vMax as text
%        str2double(get(hObject,'String')) returns contents of vMax as a double


% --- Executes during object creation, after setting all properties.
function vMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s=strcat(datestr(clock,'yyyy-mm-dd-HHMM'),'m',datestr(clock,'ss'),'s'); 
filename=sprintf('QualityOfSearch_date%s.pdf',s);
export_fig(handles.axes4,filename)
filename=sprintf('ConvergenceRate_date%s.pdf',s);
export_fig(handles.axes3,filename)
filename=sprintf('ExploredArea_date%s.pdf',s);
export_fig(handles.axes2,filename)
filename=sprintf('EPSO_date%s.pdf',s);
export_fig(handles.axes1,filename)
filename=sprintf('Competition_date%s.pdf',s);
export_fig(handles.axes5,filename)
%print(F,'-dpdf','test.pdf')
