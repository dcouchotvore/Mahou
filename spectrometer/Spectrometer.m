function varargout = Spectrometer(varargin)
% SPECTROMETER MATLAB code for Spectrometer.fig
%      SPECTROMETER, by itself, creates a new SPECTROMETER or raises the existing
%      singleton*.
%
%      H = SPECTROMETER returns the handle to a new SPECTROMETER or the handle to
%      the existing singleton*.
%
%      SPECTROMETER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPECTROMETER.M with the given input arguments.
%
%      SPECTROMETER('Property','Value',...) creates a new SPECTROMETER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Spectrometer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Spectrometer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Spectrometer

% Last Modified by GUIDE v2.5 16-Aug-2012 10:24:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Spectrometer_OpeningFcn, ...
                   'gui_OutputFcn',  @Spectrometer_OutputFcn, ...
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

% --- Executes just before Spectrometer is made visible.
function Spectrometer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Spectrometer (see VARARGIN)

global method IO FPAS Interferometer_Stage JY fsToMm2Pass;

%set the function that will execute when the figure closes
set(hObject,'CloseRequestFcn',@cleanup);

% Choose default command line output for Spectrometer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Splash Screen
splash = SplashScreen('Garrett-Roe 2D-IR Spectrometer', 'splash_screen.jpg');
splash.addText(30,50, 'Garrett-Roe 2D-IR Spectrometer', 'FontSize', 30, 'Color', [0 0 0.6] )

Constants;
scales.ch32 = [0:31];

%Default method on startup.
%method = Method_RawData;
method = Method_Test_Phasing;
%method.InitializePlot(handles); % @@@ rethink this.

global IO;
try
  IO = IO_Interface;
  IO.CloseClockGate();
catch
  warning('IO not enabled');
end

try
  Interferometer_Stage = PI_TranslationStage('COM3', fsToMm2Pass, 'editMotor1');
catch
  warning('PI stage not enabled');
end

FPAS = Sampler_FPAS.getInstance;
TEST = Sampler_test.getInstance;

JY = '';

%Default method on startup.
method = Method_Show_Spectrum(TEST,IO,JY,Interferometer_Stage,handles,handles.uipanelParameters,...
  handles.axesMain,handles.axesRawData,handles.uipanelNoise);

delete(splash);

% --- Outputs from this function are returned to the command line.
function varargout = Spectrometer_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pbGo.
function pbGo_Callback(hObject, eventdata, handles)
% hObject    handle to pbGo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global method;

% Called recursively if scan is running
if method.ScanIsRunning == true
    %set(handles.pbGo, 'String', 'Go', 'BackgroundColor', 'green');
    set(handles.pbGo, 'String', 'Stopping', 'BackgroundColor', 'yellow');
    method.ScanIsStopping = true;
    return;
end

set(handles.pbGo, 'String', 'Stop', 'BackgroundColor', [1.0 0.0 0.0]);

try
  method.Scan;
catch E
  
  set(handles.pbGo, 'String', 'Go', 'BackgroundColor', 'green');
  cleanup('','');
  rethrow(E);
end

set(handles.pbGo, 'String', 'Go', 'BackgroundColor', 'green');

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

close(gcf); %this will execute the CloseRequestFcn -> cleanup

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
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

% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in popupMethods.
function popupMethods_Callback(hObject, eventdata, handles)
% hObject    handle to popupMethods (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupMethods contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupMethods

updateMethod(handles);

function updateMethod(handles)
%update the current method based on the values of the popup menus Method
%and DataSource. Gate and Spectrometer could be added but not yet
%implemented. Called by popupMethods_Callback and popupDataSource_Callback
global method FPAS IO JY Interferometer_Stage;

%clear old class instance
delete(method);

val = get(handles.popupMethods,'Value');
list = get(handles.popupMethods,'String');
str = list{val}; %select contents of desired cell
str_method = str(1:end-2); %chop off the ".m"

val = get(handles.popupDataSource,'Value');
list = get(handles.popupDataSource,'String');
str = list{val}; %select contents of desired cell
str_sampler = str(1:end-2); %chop off the ".m"
sampler = feval([str_sampler '.getInstance']);

%method = Method_Show_Spectrum(TEST,IO,JY,handles,handles.uipanelParameters,...
%  handles.axesMain,handles.axesRawData,handles.uipanelNoise);
method = feval(str_method,sampler,IO,JY,Interferometer_Stage,handles,handles.uipanelParameters,...
  handles.axesMain,handles.axesRawData,handles.uipanelNoise);

% switch get(handles .popupMethods, 'Value')
%     case 1    
%         method = Method_RawData;
%     case 2
%         method = Method_Spectrum;
%     case 3
%         method = Method_2DScan_SoftPhasing;
%     otherwise
%         error('Nonexistent data acquisition method selected');
% end
% 
% %EnableParameters(handles);
% method.InitializePlot(handles)


% --- Executes during object creation, after setting all properties.
function popupMethods_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupMethods (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
DEFAULT = 'Method_Show_Spectrum.m';
name_struct = dir('Method_*.m');
name_cell = {name_struct.name};
set(hObject,'String',name_cell);
val = find(strcmpi(name_cell,DEFAULT));
set(hObject,'Value',val); %set default



% --- Executes on selection change in popupDataSource.
function popupDataSource_Callback(hObject, eventdata, handles)
% hObject    handle to popupDataSource (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupDataSource contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupDataSource
updateMethod(handles);


% --- Executes during object creation, after setting all properties.
function popupDataSource_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupDataSource (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
DEFAULT = 'Sampler_FPAS.m';
name_struct = dir('Sampler_*.m');
name_cell = {name_struct.name};
set(hObject,'String',name_cell);
val = find(strcmpi(name_cell,DEFAULT));
set(hObject,'Value',val); %set default


% --- Executes on slider movement.
function sliderNoiseGain_Callback(hObject, eventdata, handles)
% hObject    handle to sliderNoiseGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global method;
method.noiseGain = 10^get(handles.sliderNoiseGain, 'Value');

% --- Executes during object creation, after setting all properties.
function sliderNoiseGain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderNoiseGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function editMotor1_Callback(hObject, eventdata, handles)
% hObject    handle to editMotor1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMotor1 as text
%        str2double(get(hObject,'String')) returns contents of editMotor1 as a double


% --- Executes during object creation, after setting all properties.
function editMotor1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMotor1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbMotor1Reset.
function pbMotor1Reset_Callback(hObject, eventdata, handles)
% hObject    handle to pbMotor1Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Interferometer_Stage;

Interferometer_Stage.SetCenter;


% --- Executes on button press in pbMotor1Go.
function pbMotor1Go_Callback(hObject, eventdata, handles)
% hObject    handle to pbMotor1Go (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Interferometer_Stage;

Interferometer_Stage.MoveTo(handles, str2double(get(handles.editMotor1, 'String')), 500, 0, 0);


% --- Executes on button press in pbMotor1Dn.
function pbMotor1Dn_Callback(hObject, eventdata, handles)
% hObject    handle to pbMotor1Dn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Interferometer_Stage;

Interferometer_Stage.MoveTo(handles, -10.0, 100, 1, 0);

% --- Executes on button press in pbMotor1Up.
function pbMotor1Up_Callback(hObject, eventdata, handles)
% hObject    handle to pbMotor1Up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Interferometer_Stage;

Interferometer_Stage.MoveTo(handles, 10.0, 100, 1, 0);


function cleanup(src,event)
%for exit
global IO FPAS method Interferometer_Stage;

disp('shutting down');

%save parameters for next time?
disp('NOT YET IMPLEMENTED: save parameters for next time');

disp('move motors to zero...')
try
  Interferometer_Stage.MoveTo([],0,10,0,0);
catch
  %?
end

disp('clean up stage')
delete(Interferometer_Stage);

disp('clean up Method')
delete(method);

disp('clean up IO')
delete(IO);

disp('clean up FPAS')
delete(FPAS);

disp('close figure')
delete(gcbf);


% --- Executes on selection change in popupDataSource.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupDataSource (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupDataSource contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupDataSource


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupDataSource (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxMainAutoY.
function checkboxMainAutoY_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxMainAutoY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxMainAutoY
val = get(hObject,'Value');
if val
  %if checked (val = 1) set auto
  set(handles.axesMain,'YLimMode','auto')
else
  %if not checked (val = 0) set man
  set(handles.axesMain,'YLimMode','man')
  ylim = get(handles.axesMain,'YLim');
  set(handles.editMainYLim1,'String',num2str(ylim(1)));
  set(handles.editMainYLim2,'String',num2str(ylim(2)));
end  


function editMainYLim2_Callback(hObject, eventdata, handles)
% hObject    handle to editMainYLim2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMainYLim2 as text
%        str2double(get(hObject,'String')) returns contents of editMainYLim2 as a double
ind = 2;

set(handles.checkboxMainAutoY,'Value',0);
ylim = get(handles.axesMain,'YLim');
val = str2double(get(hObject,'String'));
if ~isnan(val)
  ylim(ind) = val;
end
set(handles.axesMain,'YLim',ylim);

% --- Executes during object creation, after setting all properties.
function editMainYLim2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMainYLim2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String','1');


function editMainYLim1_Callback(hObject, eventdata, handles)
% hObject    handle to editMainYLim1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMainYLim1 as text
%        str2double(get(hObject,'String')) returns contents of editMainYLim1 as a double
ind = 1;

set(handles.checkboxMainAutoY,'Value',0);
ylim = get(handles.axesMain,'YLim');
val = str2double(get(hObject,'String'));
if ~isnan(val)
  ylim(ind) = val;
end
set(handles.axesMain,'YLim',ylim);

% --- Executes during object creation, after setting all properties.
function editMainYLim1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMainYLim1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String','0');


% --- Executes on button press in pbBackground.
function pbBackground_Callback(hObject, eventdata, handles)
% hObject    handle to pbBackground (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global method

% Called recursively if scan is running
if method.ScanIsRunning == true
    beep
    return
end

set(hObject, 'String', 'Background running...', 'BackgroundColor', [1.0 0.0 0.0]);

try
  method.BackgroundAcquire;
catch E
  
  set(hObject, 'String', 'Background', 'BackgroundColor', [0.8 0.8 0.8]);
  cleanup('','');
  rethrow(E);
end

set(hObject, 'String', 'Background', 'BackgroundColor', [0.8 0.8 0.8]);

% --- Executes on button press in pbBackgroundReset.
function pbBackgroundReset_Callback(hObject, eventdata, handles)
% hObject    handle to pbBackgroundReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global method
if method.ScanIsRunning == true
    beep
    return
end
try
    method.BackgroundReset;
catch E
    cleanup('','');
    rethrow(E);
end
