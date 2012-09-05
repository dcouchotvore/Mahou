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

% Last Modified by GUIDE v2.5 04-Sep-2012 15:03:35

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

% Splash Screen
splash = SplashScreen('Garrett-Roe 2D-IR Spectrometer', 'splash_screen.jpg');
splash.addText(30,50, 'Garrett-Roe 2D-IR Spectrometer', 'FontSize', 30, 'Color', [0 0 0.6] )

%add menu item
hmenu = uimenu(gcf,'Label','MCT','Tag','menuMCT');
hmenuitems(1)  = uimenu(hmenu,'Label','Set gain','Callback',{@(src,eventdata) menuMCT_callback(src,eventdata)});
%hmenuitems(1)  = uimenu(hmenu,'Label','Set gain','Callback',@test_menu_callback);
hmenuitems(2)  = uimenu(hmenu,'Label','Set trim','Callback',{@(src,eventdata) menuMCT_callback(src,eventdata)});

Constants;
% scales.ch32 = [0:31];     % @@@ Not sure we use this anymore.

%Default method on startup.
%method = Method_RawData;
%method = Method_Test_Phasing;
%method.InitializePlot(handles); % @@@ rethink this.

IO = [];
try
  IO = IO_Interface;
  IO.CloseClockGate();
catch
  warning('SGRLAB:SimulationMode','IO not enabled');
end

try
  Interferometer_Stage = PI_TranslationStage('COM3', fsToMm2Pass, 'editMotor1');
catch
  warning('SGRLAB:SimulationMode','PI stage not enabled');
end

FPAS = Sampler_FPAS.getInstance;

JY = Monochromator_JY.getInstance;
JY.InitializeGui(handles.uipanelMonochromator);

%Default method on startup.
method = Method_Show_Spectrum(FPAS,IO,JY,Interferometer_Stage, handles,handles.pnlParameters,handles.axesMain,handles.axesRawData,handles.pnlNoise);

delete(splash);

% Update handles structure
guidata(hObject, handles);

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

%method = Method_Show_Spectrum(TEST,IO,JY,handles,handles.pnlParameters,...
%  handles.axesMain,handles.axesRawData,handles.pnlNoise);
method = feval(str_method,sampler,IO,JY,Interferometer_Stage,handles,handles.pnlParameters,...
  handles.axesMain,handles.axesRawData,handles.pnlNoise);

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

function menuMCT_callback(varargin)
global method
PANEL_NAME = 'uipanelGainTrim';

src = 'uninited src';
eventdata =  'uninited eventdata';

if nargin >= 1
  src = varargin{1};
end
if nargin >= 2
  eventdata = varargin{2};
end

cleanupPanel(PANEL_NAME);

%[obj,fig] = gcbo;
%fig = gcf;
%set(fig,'Visible','off');

%%open new figure
%f = figure;clf;%('Name','Gains','NumberTitle','off');

%get handles to ui elements
handles = guidata(gcf);

%hide overlapped things because they are in different stacks and just make
%a mess of stuff
set(handles.pnlRawData,'Visible','off');
set(handles.pnlNoise,'Visible','off');
set(handles.sliderNoiseGain,'Visible','off');

%open new panel
set(handles.axesMain,'units','normalized')
pos = get(handles.axesMain,'Position');
xoffset = -0.05;
height = 0.3;
uipanelGainTrim = uipanel(gcf,'units','normalized',...
  'Position',[pos(1)+xoffset pos(2)-height pos(3)-xoffset*1.05 height],...
  'Tag',PANEL_NAME);
% pbDone = uicontrol(uipanelGainTrim,'Style','PushButton','Tag','pbGainTrimDone',...
%   'units','normalized',...
%   'Position',[0 0.7 0.11 0.3],...
%   'String','Done',...
%   'Callback',{@(src,eventinfo) cleanup(src,eventinfo,uipanelGainTrim)});
pbDone = uicontrol(uipanelGainTrim,'Style','PushButton','Tag','pbGainTrimDone',...
  'units','normalized',...
  'Position',[0 0.8 0.11 0.2],...
  'String','Done',...
  'Callback',{@(src,eventinfo) cleanupPanel(PANEL_NAME)});

label = get(src,'Label');
switch label
  case 'Set gain'
    newGainFunction(uipanelGainTrim,method);
  case 'Set trim'
    newTrimFunction(uipanelGainTrim,method);
end

%waitfor(f);
%disp('done')
%set(fig,'Visible','on');

function newGainFunction(uipanelGainTrim,method)

%if nargin >=1
%  method = varargin{1};   
%end
nPix = method.nPixelsPerArray;
nArrays = method.nArrays;
% @@@
%nPix = 32;
%nArrays = 2;

set(uipanelGainTrim,'Title','Set gain');

%a  = axes('units','normalized','OuterPosition',[0.05 0.2 0.9 0.8]);
%plot(a,1:10,rand(1,10));
HIGH = 1; 
LOW = 0;
bgHighLow = uibuttongroup(uipanelGainTrim,'Tag','bgHighLow','units','normalized',...
  'Position',[0.0 0.0 0.11 .4]);
uicontrol(bgHighLow,'Style','radiobutton',...
  'String','High','units','normalized','Position',[0 0 1 0.5],...
  'UserData',HIGH);
uicontrol(bgHighLow,'Style','radiobutton',...
  'String','Low','units','normalized','Position',[0 0.5 1 0.5],...
  'UserData',LOW);
set(bgHighLow,'SelectedObject',[]);
set(bgHighLow,'SelectionChangeFcn',{@(src,event) bgGainTrim_selection_change(src,event,uipanelGainTrim,method)});


bgBatchSet = uibuttongroup(uipanelGainTrim,'Tag','bgBatchSetGain','units','normalized',...
  'Position',[0.0 .4 0.11 .4]);
uicontrol(bgBatchSet,'Style','radiobutton',...
  'String','All 7','units','normalized','Position',[0 0 1 0.5],...
  'UserData',7);
uicontrol(bgBatchSet,'Style','radiobutton',...
  'String','All 0','units','normalized','Position',[0 0.5 1 0.5],...
  'UserData',0);
set(bgBatchSet,'SelectedObject',[]);
set(bgBatchSet,'SelectionChangeFcn',{@(src,event) bgGainTrim_selection_change(src,event,uipanelGainTrim,method)});


%make sliders / text boxes
height = 1/nArrays;
width = 0.89/nPix;

PnlOpt.title = 'Gain';
PnlOpt.bordertype = 'none';
PnlOpt.titleposition = 'centertop';
PnlOpt.fontweight = 'bold';
SldrOpt.min = 0;
SldrOpt.max = 7;
SldrOpt.SliderStep = [1 1];
SldrOpt.value = 7; % read from somewhere?
SldrOpt.Position = [0 0.4 0.7 0.6];
EditOpts = {'fontsize',9,'units','normalized','Position',[0 0 1 0.4],...
  'Tag','edit'};
LabelOpts = {'fontsize',6,'fontweight','b','Visible','off'};
numFormat = '%1.0f';

count = 0;    
for i = 1:nArrays
  for j = 1:nPix
    count = count+1;
    PnlOpt.position = [0.11+width*(j-1) 0.5*(nArrays-i) width height];
    PnlOpt.title = num2str(j +(i-1)*nPix);
    SldrOpt.callback = {@sliderGain_Callback};
    SldrOpt.Tag = sprintf('slider%i',count);
    slider = sliderPanel(uipanelGainTrim,PnlOpt,SldrOpt,EditOpts,LabelOpts,numFormat);
    set(slider, 'UserData', count);
  end
end

function sliderGain_Callback(src, eventdata)
global method;

  method.source.sampler.SetGain(get(src,'UserData'), round(get(src,'Value')));

function newTrimFunction(uipanelGainTrim, method)

nPix = method.nPixelsPerArray;
nArrays = method.nArrays;

set(uipanelGainTrim,'Title','Set trim');

bgBatchSet = uibuttongroup(uipanelGainTrim,'Tag','bgBatchSetTrim','units','normalized',...
  'Position',[0.0 .4 0.11 .4]);
uicontrol(bgBatchSet,'Style','radiobutton',...
  'String','All 255','units','normalized','Position',[0 0 1 0.5],...
  'UserData',255);
uicontrol(bgBatchSet,'Style','radiobutton',...
  'String','All 0','units','normalized','Position',[0 0.5 1 0.5],...
  'UserData',0);
set(bgBatchSet,'SelectedObject',[]);
set(bgBatchSet,'SelectionChangeFcn',{@(src,event) bgGainTrim_selection_change(src,event,uipanelGainTrim,method)});

%make sliders / text boxes
height = 1/nArrays;
width = 0.89/nPix;

PnlOpt.title = 'Gain';
PnlOpt.bordertype = 'none';
PnlOpt.titleposition = 'centertop';
PnlOpt.fontweight = 'bold';
SldrOpt.min = 0;
SldrOpt.max = 255;
SldrOpt.SliderStep = [1 1];
SldrOpt.value = 255; % read from somewhere?
SldrOpt.Position = [0 0.4 0.7 0.6];
EditOpts = {'fontsize',9,'units','normalized','Position',[0 0 1 0.4],'Tag','edit'};
LabelOpts = {'fontsize',6,'fontweight','b','Visible','off'};
numFormat = '%1.0f';

count = 0;    
for i = 1:nArrays
  for j = 1:nPix
    count = count+1;
    PnlOpt.position = [0.11+width*(j-1) 0.5*(nArrays-i) width height];
    PnlOpt.title = num2str(j +(i-1)*nPix);
    SldrOpt.callback = {@sliderTrim_Callback};
    SldrOpt.Tag = sprintf('slider%i',count);
    slider = sliderPanel(uipanelGainTrim,PnlOpt,SldrOpt,EditOpts,LabelOpts,numFormat);
    set(slider, 'UserData', count);
  end
end

function sliderTrim_Callback(src, eventdata)
global method;

  method.source.sampler.SetTrim(get(src,'UserData'), round(get(src,'Value')));

function bgGainTrim_selection_change(src,eventdata,uipanelGainTrim,method)
s = get(src,'Tag');
val = get(eventdata.NewValue,'UserData');
handles = guidata(src);
sliders = findobj(uipanelGainTrim,'-regexp','Tag','slider[\d]');
edits = findobj(uipanelGainTrim,'-regexp','Tag','edit');
switch s
  case 'bgHighLow'
    method.source.sampler.SetGainRange(val);
  case 'bgBatchSetGain'
    method.source.sampler.SetGainAll(val);
    set(sliders,'Value',val);
    set(edits,'String',sprintf('%1.0f',val));
  case 'bgBatchSetTrim'
    method.source.sampler.SetTrimAll(val);
    set(sliders,'Value',val);
    set(edits,'String',sprintf('%1.0f',val));
end


function cleanupPanel(name)
h = findobj(gcf,'Tag',name);
delete(h);
%make sure that other elements are visible
handles = guidata(gcf);
set(handles.pnlRawData,'Visible','on');
set(handles.pnlNoise,'Visible','on');
set(handles.sliderNoiseGain,'Visible','on');



