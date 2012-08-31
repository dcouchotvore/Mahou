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

% Last Modified by GUIDE v2.5 31-Aug-2012 14:22:43

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
% scales.ch32 = [0:31];     % @@@ Not sure we use this anymore.

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
  warning('Spectrometer:TranslationStage', 'PI stage not enabled');
end

FPAS = Sampler_FPAS.getInstance;
TEST = Sampler_test.getInstance;

JY = Monochromator_JY.getInstance;
JY.InitializeGui(handles.uipanelMonochromator);

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
global method IO JY Interferometer_Stage;

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
%Here we will populate the popup with all class files called Sampler_* but
%we have to check the right folder. So we find the name of this mfile
%(Spectrometer.m) and its path, then extract the path part, and use this to
%find the classes we want.
fullNameAndPath = mfilename('fullpath'); %name of this m-file 
[pathpart,~,~]=fileparts(fullNameAndPath);%we want path
name_struct = dir([pathpart '\Method_*.m']);
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
%Here we will populate the popup with all class files called Sampler_* but
%we have to check the right folder. So we find the name of this mfile
%(Spectrometer.m) and its path, then extract the path part, and use this to
%find the classes we want.
fullNameAndPath = mfilename('fullpath'); %name of this m-file 
[pathpart,~,~]=fileparts(fullNameAndPath);%we want path
name_struct = dir([pathpart '\Sampler_*.m']);
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

% --- Executes during object creation, after setting all properties.
function sliderMCTGain00_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain00 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain01_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain01 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain02_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain02 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain03_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain03 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain04_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain04 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain05_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain05 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain03_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain03 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function sliderMCTGain07_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain07 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function sliderMCTGain06_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain06 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain08_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain08 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain09_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain09 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function sliderMCTGain12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function sliderMCTGain16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function sliderMCTGain17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function slider29sliderMCTGain27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider29sliderMCTGain27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function slider34sliderMCTGain32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider34sliderMCTGain32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain35_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain39_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain38_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain37_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function sliderMCTGain36_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain43_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain42_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain41_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain40_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain47_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain46_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain45_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain44_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain51_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain50_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain49_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain48_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain55_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain54_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain53_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain52_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain59_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain58_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain57_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain56_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain63_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain63 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain62_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain62 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain61_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain61 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function sliderMCTGain60_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function sliderMCTGain_Callback(hObject, eventdata, handles)
% hObject    handle to sliderMCTGain00 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

val = get(hObject, 'Value');
val = 10^((val-0.5)*2);
name = get(hObject, 'Tag');
channel = str2double(name(14:15));
if strcmp(get(handles.panelMCTGain, 'title'), 'MCT Gain')
  % @@@ Insert call to set gain for this channel
else 
  % @@@ Insert call to set gain for this channel
end

% --- Executes on button press in pbMCTGainClose.
function pbMCTGainClose_Callback(hObject, eventdata, handles)
% hObject    handle to pbMCTGainClose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.panelMCTGain, 'visible', 'off');
set(handles.pnlRawData, 'visible', 'on');
set(handles.uipanelNoise, 'visible', 'on');

% --------------------------------------------------------------------
function menuMCT_Callback(hObject, eventdata, handles)
% hObject    handle to menuMCT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuMCTGain_Callback(hObject, eventdata, handles)
% hObject    handle to menuMCTGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.pnlRawData, 'visible', 'off');
set(handles.uipanelNoise, 'visible', 'off');
set(handles.panelMCTGain, 'title', 'MCT Gain');
set(handles.panelMCTGain, 'visible', 'on');


% --------------------------------------------------------------------
function menuMCTTrim_Callback(hObject, eventdata, handles)
% hObject    handle to menuMCTTrim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.pnlRawData, 'visible', 'off');
set(handles.uipanelNoise, 'visible', 'off');
set(handles.panelMCTGain, 'title', 'MCT Gain');
set(handles.panelMCTGain, 'visible', 'on');
